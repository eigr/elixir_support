defmodule CloudState.EventSourcedHandler do
  use GenServer
  require Logger

  alias Cloudstate.{Command, ClientAction, SideEffect}

  alias Cloudstate.Eventsourced.{
    EventSourcedStreamIn,
    EventSourcedStreamOut,
    EventSourcedInit,
    EventSourcedSnapshot,
    EventSourcedEvent,
    EventSourcedReply
  }

  @event_sourced_registry :event_sourced_entities_registry

  # Cliet API
  def start_link(state),
    do: GenServer.start_link(__MODULE__, state, name: via_tuple(state[:instance]))

  def handle_init(instance, payload),
    do: GenServer.call(via_tuple(instance), {:init, payload})

  def handle_command(instance, payload),
    do: GenServer.call(via_tuple(instance), {:command, payload})

  def handle_event(instance, payload),
    do: GenServer.call(via_tuple(instance), {:event, payload})

  def handle_snapshot(instance, payload),
    do: GenServer.call(via_tuple(instance), {:snapshot, payload})

  # Server Callbacks

  @impl true
  def init(state) do
    Logger.info("Starting EventSourced Entity instance id: #{inspect(state[:instance])}")
    entity = get_entity(state)
    Logger.debug("Entity #{inspect(entity)}")
    {:ok, state}
  end

  @impl true
  def handle_call({:init, payload}, _from, state) do
    Logger.debug("Init message #{inspect(payload)} with options: #{inspect(state[:opts])}")
    entity = get_entity(state)
    {:reply, payload, state}
  end

  @impl true
  def handle_call({:command, payload}, _from, state) do
    Logger.info("Handle command #{inspect(payload)}")
    entity = get_entity(state)
    service = payload |> get_service
    request = payload |> get_type |> get_payload(payload.payload.value)

    resul = apply(entity, :handle_command, [service, request, state])
    {:reply, resul, state}
  end

  @impl true
  def handle_call({:event, payload}, _from, state) do
    Logger.info("Handle event #{inspect(payload)}")
    entity = get_entity(state)
    {:reply, payload, state}
  end

  @impl true
  def handle_call({:snapshot, payload}, _from, state) do
    Logger.info("Handle snapshot #{inspect(payload)}")
    entity = get_entity(state)
    {:reply, payload, state}
  end

  defp via_tuple(instance),
    do: {:via, Registry, {@event_sourced_registry, instance}}

  defp get_entity(state) do
    opts = state[:opts]
    opts.entity
  end

  defp get_type(payload) do
    type = payload.payload.type_url |> String.split("/") |> Enum.at(1)
    ("Elixir." <> type) |> String.to_existing_atom()
  end

  defp get_payload(module, value), do: module.decode(value)

  defp get_service(payload), do: Macro.underscore(payload.name) |> String.to_atom()
end
