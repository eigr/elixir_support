defmodule CloudState.EventSourcedEntitySupervisor do
    use DynamicSupervisor
    alias CloudState.EventSourcedHandler

    def start_link(_arg),
        do: DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)

    def init(_arg),
        do: DynamicSupervisor.init(strategy: :one_for_one)

    def start_child(entity_instance) do
        DynamicSupervisor.start_child(
        __MODULE__,
        %{id: EventSourcedHandler, start: { EventSourcedHandler, :start_link,  [entity_instance]}, restart: :transient})
    end
end