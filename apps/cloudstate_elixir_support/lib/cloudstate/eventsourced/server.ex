defmodule CloudState.EventSourced.Server do
  use GRPC.Server, service: Cloudstate.Eventsourced.EventSourced.Service
  require Logger
  alias Cloudstate.Eventsourced.EventSourcedStreamIn
  alias CloudState.{EventSourcedEntitySupervisor, EventSourcedHandler}

  @spec handle(Cloudstate.Eventsourced.EventSourcedStreamIn.t(), GRPC.Server.Stream.t()) ::
          Cloudstate.Eventsourced.EventSourcedStreamOut.t()
  def handle(request, _stream) do
    Enum.each(request, fn chunk ->
      case chunk do
        %EventSourcedStreamIn{message: {:init, _}} ->
          handle_init(elem(chunk.message, 1))

        %EventSourcedStreamIn{message: {:command, _}} ->
          handle_command(elem(chunk.message, 1))

        _ ->
          Logger.info("No handler was found for this protocol message. Message #{chunk}")
      end

      # Send response
      # Server.send_reply(stream, note)
    end)
  end

  defp handle_init(message) do
    Logger.info("Incoming Init message #{inspect(message)}")
    instance = message |> get_instance_id

    args = %{
      instance: instance,
      opts: Application.fetch_env!(:cloudstate_elixir_support, :register_options)
    }

    EventSourcedEntitySupervisor.start_child(args)
    EventSourcedHandler.handle_init(instance, message)
  end

  defp handle_command(message) do
    Logger.info("Incoming Command message #{inspect(message)}")
    instance = message |> get_instance_id
    result = EventSourcedHandler.handle_command(instance, message)
    Logger.info("Response from Entity #{inspect result}")
  end

  defp get_instance_id(msg), do: msg.entity_id
end
