defmodule CloudState.EventSourced.Server do
    use GRPC.Server, service: Cloudstate.Eventsourced.EventSourced.Service
    require Logger
    alias CloudState.{EventSourcedEntitySupervisor, EventSourcedHandler}
    alias Cloudstate.Eventsourced.EventSourcedStreamIn

    @spec handle(Cloudstate.Eventsourced.EventSourcedStreamIn.t, GRPC.Server.Stream.t) :: Cloudstate.Eventsourced.EventSourcedStreamOut.t
    def handle(request, _stream) do
        Enum.each(request, fn frame ->
            case frame do
                %EventSourcedStreamIn{message: {:init, _}} ->  
                    handle_init(frame.message)

                %EventSourcedStreamIn{message: {:command, _}} ->  
                    handle_command(frame.message)
            end
            
            # Send response
            #Server.send_reply(stream, note)
        end)
        
    end

    defp handle_init(message) do
        Logger.info("Incoming Init message #{inspect message}")
        message
        |> elem(1)
        |> EventSourcedEntitySupervisor.start_child()
        
    end

    defp handle_command(message) do
        Logger.info("Incoming Command message #{inspect message}")
    end

end
