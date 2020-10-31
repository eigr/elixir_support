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
  def start_link(args),
    do: GenServer.start_link(__MODULE__, args, name: via_tuple(args[:instance]))

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
  def init(args) do
    Logger.info("Starting EventSourced Entity instance id: #{inspect(args[:instance])}")
    {:ok, args}
  end

  @impl true
  def handle_call({:init, payload}, _from, args) do
    Logger.debug("Init message #{inspect(payload)} with options: #{inspect(args[:opts])}")
    {:reply, payload, args}
  end

  @impl true
  def handle_call({:command, payload}, _from, args) do
    Logger.info("Handle command #{inspect(payload)}")
    {:reply, payload, args}
  end

  @impl true
  def handle_call({:event, payload}, _from, args) do
    Logger.info("Handle event #{inspect(payload)}")
    {:reply, payload, args}
  end

  @impl true
  def handle_call({:snapshot, payload}, _from, args) do
    Logger.info("Handle snapshot #{inspect(payload)}")
    {:reply, payload, args}
  end

  defp via_tuple(instance),
    do: {:via, Registry, {@event_sourced_registry, instance}}
end
