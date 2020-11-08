defmodule CloudState.EventSourced.Server do
  use GRPC.Server, service: Cloudstate.Eventsourced.EventSourced.Service
  require Logger
  alias GRPC.Server
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
              send_response(stream, result, context)

            {:emit, event, result, context} ->
              emit_events(stream, event, result, context)

            {:emit, event, forward, result, context} ->
              send_forwards(stream, event, forward, result, context)

            {:error, reason, context} ->
              send_error(stream, reason, context)
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

  defp send_error(stream, reason, context) do
    # Send response
    # Server.send_reply(stream, response)
  end

  defp send_response(stream, result, context) do
    # Send response

    # Server.send_reply(stream, response)
  end

  defp emit_events(stream, event, result, context) do
    # Send response
    reply = EventSourcedReply.new(command_id: 1)
    response = EventSourcedStreamOut.new(reply: reply)
    Server.send_reply(stream, response)
  end

  defp send_forwards(stream, event, forward, result, context) do
    # Send response
    # Server.send_reply(stream, response)
  end
end
