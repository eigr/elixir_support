defmodule CloudState.EntityDiscoveryHandler do
    use GenServer
    alias Cloudstate.{EntitySpec,ServiceInfo}

    def child_spec(opts) do
        %{
            id: __MODULE__, 
            start: {__MODULE__, :start_link, [opts]}, 
            type: :worker,
            restart: :transient,
        }
    end

    # Client functions
    def start_link(opts) do
        GenServer.start_link(__MODULE__, opts)
    end

    def discover(pid, proxy_info) do
        GenServer.call(pid, {:discover, proxy_info})
    end

    # Server callbacks

    @impl true
    def init(state) do
        {:ok, state}
    end

    @impl true
    def handle_call({:discover, proxy_info}, _from, state) do
        entity_spec = EntitySpec.new(proto: nil, entities: nil, service_info: nil)
        {:reply, entity_spec, state}
    end
end
