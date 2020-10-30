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
    EventSourcedReply,
  }

  @event_sourced_registry :event_sourced_entities_registry

  # Cliet API
  def start_link(name),
    do: GenServer.start_link(__MODULE__, name, name: via_tuple(name))

  # Server Callbacks

  @impl true
  def init(name) do
    Logger.info("Starting EventSourced Entity instance #{inspect(name)}")
    {:ok, name}
  end

  @impl true
  def handle_call({:init, payload}, _from, name) do
    {:reply, payload, name}
  end

  @impl true
  def handle_call({:command, payload}, _from, name) do
    {:reply, payload, name}
  end

  @impl true
  def handle_call({:event, payload}, _from, name) do
    {:reply, payload, name}
  end

  @impl true
  def handle_call({:snapshot, payload}, _from, name) do
    {:reply, payload, name}
  end

  defp via_tuple(name) ,
    do: {:via, Registry, {@event_sourced_registry, name} }
end
