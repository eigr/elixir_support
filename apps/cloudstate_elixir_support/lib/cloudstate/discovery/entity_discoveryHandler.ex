defmodule Cloudstate.EntityDiscoveryHandler do
    use GenServer
    alias Cloudstate.{EntitySpec,ServiceInfo}

    def init(state) do
        {:ok, state}
    end
end
