defmodule CloudState.EventSourced.Server do
  use GRPC.Server, service: Cloudstate.Eventsourced.EventSourced.Service
  require Logger
  alias GRPC.Server
  alias Cloudstate.{ClientAction, Reply, Forward, Failure}
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
          Logger.info("No handler was found for this protocol message. Message #{chunk}")
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
    # Send response

    with {:ok, builder} <- create_reply_builder(msg),
         {:ok, action_builder} <- create_action(msg, builder),
         {:ok, events_builder} <- create_events(msg, action_builder),
         {:ok, out} <- create_side_effects(msg, events_builder) do
      # send complete response
      Logger.info("Send response: #{inspect out}")
      Server.send_reply(stream, out)
      # else
    end
  end

  defp create_reply_builder(msg) do
    context = Map.get(msg, :context)
    {:ok, EventSourcedReply.new(command_id: context.command_id)}
  end

  defp create_action(msg, builder) do
    context = Map.get(msg, :context)
    response = Map.get(msg, :response)

    response =
      if response != nil do
        # Todo here
        event_module = response.__struct__ 
        event_name = event_module |> to_string |> String.replace("Elixir.", "")
        values = event_module.encode(response) || []

        Logger.info("Bytes of value: #{inspect values}")

        any = Google.Protobuf.Any.new(type_url: "type.googleapis.com/#{event_name}", value: :binary.bin_to_list(values))
        reply = Reply.new(payload: any)
        action = ClientAction.new(action: {:reply, reply})
        #{:ok, %{builder | client_action: action}}
        out = EventSourcedStreamOut.new(message: {:reply, %{builder | client_action: action}})
        {:ok, out}
      else
        {:ok, builder}
      end

      response
  end

  defp create_events(response, action_builder) do
    context = Map.get(response, :context)

    if context.events != nil and List.first(context.events) != nil do
      # Todo handle events here
    end

    {:ok, action_builder}
  end

  defp create_side_effects(response, events_builder) do
    context = Map.get(response, :context)
    {:ok, events_builder}
  end

  defp create_response(message) do
  end

  defp send_response(%{status: :error, result: _, context: _} = response, stream) do
  end
end
