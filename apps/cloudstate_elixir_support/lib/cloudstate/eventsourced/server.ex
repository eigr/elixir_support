defmodule CloudState.EventSourced.Server do
  use GRPC.Server, service: Cloudstate.Eventsourced.EventSourced.Service
  require Logger
  alias GRPC.Server
  alias Cloudstate.{ClientAction, Reply}
  alias CloudState.{EventSourcedEntitySupervisor, EventSourcedHandler}
  alias Cloudstate.Eventsourced.{EventSourcedStreamIn, EventSourcedStreamOut, EventSourcedReply}

  @spec handle(Cloudstate.Eventsourced.EventSourcedStreamIn.t(), GRPC.Server.Stream.t()) ::
          Cloudstate.Eventsourced.EventSourcedStreamOut.t()
  def handle(request, stream) do
    Enum.each(request, fn chunk ->
      case chunk do
        %EventSourcedStreamIn{message: {:init, _}} ->
          handle_init(elem(chunk.message, 1))

        %EventSourcedStreamIn{message: {:command, _}} ->
          case handle_command(elem(chunk.message, 1)) do
            {:ok, result, context} ->
              send_response(%{status: :ok, response: result, context: context}, stream)

            {:error, reason, context} ->
              send_response(%{status: :error, result: reason, context: context}, stream)
          end

        _ ->
          Logger.info("No handler was found for this protocol message. Message #{inspect(chunk)}")
      end
    end)
  end

  defp handle_init(message) do
    Logger.info("Incoming Init message #{inspect(message)}")
    entity_id = message |> get_entity_id
    opts = Application.fetch_env!(:cloudstate_elixir_support, :register_options)

    context = %CloudState.EventSourced.Context{
      name: opts.name,
      entity: opts.entity,
      persistence_id: opts.persistence_id,
      entity_id: entity_id,
      state: []
    }

    EventSourcedEntitySupervisor.start_child(context)
    EventSourcedHandler.handle_init(entity_id, message)
  end

  defp handle_command(message) do
    Logger.info("Incoming Command message #{inspect(message)}")
    entity_id = message |> get_entity_id
    result = EventSourcedHandler.handle_command(entity_id, message)
    Logger.info("Response from Entity #{inspect(result)}")
    result
  end

  defp get_entity_id(msg), do: msg.entity_id

  defp send_response(%{status: :ok, response: _, context: _} = msg, stream) do
    with {:ok, builder} <- create_reply_builder(msg),
         {:ok, action_builder} <- create_action(msg, builder),
         {:ok, events_builder} <- create_events(msg, action_builder),
         {:ok, effects_builder} <- create_side_effects(msg, events_builder),
         {:ok, streamOut} <- create_response(effects_builder) do
      Logger.info("Send response: #{inspect(streamOut)}")
      Server.send_reply(stream, streamOut)
      # else
    end
  end

  defp send_response(%{status: :error, result: _, context: _} = _response, _stream) do
  end

  defp create_reply_builder(msg) do
    context = Map.get(msg, :context)
    {:ok, EventSourcedReply.new(command_id: context.command_id)}
  end

  defp create_action(msg, builder) do
    _context = Map.get(msg, :context)
    response = Map.get(msg, :response)

    response =
      if response != nil do
        event_module = response.__struct__
        event_name = event_module |> to_string |> String.replace("Elixir.", "")
        values = event_module.encode(response) || []

        any =
          if "type.googleapis.com/#{event_name}" == "type.googleapis.com/Google.Protobuf.Empty" do
            Google.Protobuf.Any.new(
              type_url: "type.googleapis.com/google.protobuf.Empty",
              value: :binary.bin_to_list(values)
            )
          else
            Google.Protobuf.Any.new(
              type_url: "type.googleapis.com/#{event_name}",
              value: :binary.bin_to_list(values)
            )
          end

        reply = Reply.new(payload: any)
        action = ClientAction.new(action: {:reply, reply})
        {:ok, %{builder | client_action: action}}
      else
        {:ok, builder}
      end

    response
  end

  defp create_events(response, action_builder) do
    context = Map.get(response, :context)

    if context.events != nil and List.first(context.events) != nil do
      # Todo handle events here
      evts =
        Enum.map(context.events, fn evt ->
          event_module = evt.__struct__
          event_name = event_module |> to_string |> String.replace("Elixir.", "")
          values = event_module.encode(evt) || []

          Google.Protobuf.Any.new(
            type_url: "type.googleapis.com/#{event_name}",
            value: :binary.bin_to_list(values)
          )
        end)

      {:ok, %{action_builder | events: evts}}
    else
      {:ok, action_builder}
    end
  end

  defp create_side_effects(response, events_builder) do
    _context = Map.get(response, :context)
    {:ok, events_builder}
  end

  defp create_response(builder) do
    out = EventSourcedStreamOut.new(message: {:reply, builder})
    {:ok, out}
  end
end
