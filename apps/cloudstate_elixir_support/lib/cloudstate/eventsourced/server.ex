defmodule CloudState.EventSourced.Server do
  use GRPC.Server, service: Cloudstate.Eventsourced.EventSourced.Service
  require Logger
  alias Cloudstate.Eventsourced.EventSourcedStreamIn
  alias CloudState.{EventSourcedEntitySupervisor, EventSourcedHandler}

  @spec handle(Cloudstate.Eventsourced.EventSourcedStreamIn.t(), GRPC.Server.Stream.t()) ::
          Cloudstate.Eventsourced.EventSourcedStreamOut.t()
  def handle(request, _stream) do
    Enum.each(request, fn frame ->
      case frame do
        %EventSourcedStreamIn{message: {:init, _}} ->
          handle_init(elem(frame.message, 1))

        %EventSourcedStreamIn{message: {:command, _}} ->
          handle_command(elem(frame.message, 1))
      end

      # Send response
      # Server.send_reply(stream, note)
    end)
  end

  defp handle_init(message) do
    Logger.info("Incoming Init message #{inspect(message)}")
    instance = message |> get_instance

    args = %{
      instance: instance,
      opts: Application.fetch_env!(:cloudstate_elixir_support, :register_options)
    }

    EventSourcedEntitySupervisor.start_child(args)
    EventSourcedHandler.handle_init(instance, message)
  end

  defp handle_command(message) do
    Logger.info("Incoming Command message #{inspect(message)}")
    instance = message |> get_instance
    EventSourcedHandler.handle_command(instance, message)
  end

  defp get_instance(msg), do: msg.entity_id
end
