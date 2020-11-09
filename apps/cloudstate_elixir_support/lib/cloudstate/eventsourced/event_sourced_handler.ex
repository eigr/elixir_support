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
  def start_link(context),
    do: GenServer.start_link(__MODULE__, context, name: via_tuple(context.entity_id))

  def handle_init(entity_id, payload),
    do: GenServer.call(via_tuple(entity_id), {:init, payload})

  def handle_command(entity_id, payload),
    do: GenServer.call(via_tuple(entity_id), {:command, payload})

  def handle_event(entity_id, payload),
    do: GenServer.call(via_tuple(entity_id), {:event, payload})

  def handle_snapshot(entity_id, payload),
    do: GenServer.call(via_tuple(entity_id), {:snapshot, payload})

  # Server Callbacks

  @impl true
  def init(context), do: initialize(context)

  @impl true
  def handle_call({:init, payload}, _from, context) do
    Logger.debug("Init message #{inspect(payload)} with options: #{inspect(context)}")
    entity = get_entity(context)
    {:reply, payload, context}
  end

  @impl true
  def handle_call({:command, payload}, _from, context) do
    Logger.info("Handle command #{inspect(payload)}")
    entity = get_entity(context)
    service = payload |> get_service
    request = payload |> get_type |> get_payload(payload.payload.value)
    command_id = payload.id

    resul = apply(entity, :handle_command, [service, request, %{context | command_id: command_id}])
    {:reply, resul, context}
  end

  @impl true
  def handle_call({:event, payload}, _from, context) do
    Logger.info("Handle event #{inspect(payload)}")
    entity = get_entity(context)
    {:reply, payload, context}
  end

  @impl true
  def handle_call({:snapshot, payload}, _from, context) do
    Logger.info("Handle snapshot #{inspect(payload)}")
    entity = get_entity(context)
    {:reply, payload, context}
  end

  defp via_tuple(instance),
    do: {:via, Registry, {@event_sourced_registry, instance}}

  defp initialize(context) do
    Logger.info("Starting EventSourced Entity instance id: #{inspect(context.entity_id)}")
    get_entity(context) |> apply(:init, [context])
  end

  defp get_entity(context) do
    context.entity
  end

  defp get_type(payload) do
    type = payload.payload.type_url |> String.split("/") |> Enum.at(1)
    ("Elixir." <> type) |> String.to_existing_atom()
  end

  defp get_payload(module, value), do: module.decode(value)

  defp get_service(payload), do: Macro.underscore(payload.name) |> String.to_atom()
end
