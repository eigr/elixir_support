defmodule CloudState.Supervisor do
    use Supervisor

    def start_link(opts) do
        Supervisor.start_link(__MODULE__, opts)
    end
    
    @impl true
    def init(opts) do
    children = [
        {CloudState.EntityDiscoveryHandler, opts}
    ]

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
    end
end