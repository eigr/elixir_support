defmodule CloudState.Supervisor do
  use Supervisor

  @event_sourced_registry :event_sourced_entities_registry

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  @impl true
  @spec init(any) :: none
  def init(opts) do
    # This is a Hack to force the gRPC library to start as a server
    Application.put_env(:grpc, :start_server, true)
    Application.put_env(:cloudstate_elixir_support, :register_options, opts, persistent: true)

    entities_childrens =
      case opts.entity.get_entity_type do
        "cloudstate.eventsourced.EventSourced" ->
          [
            {CloudState.EventSourcedEntitySupervisor, []},
            {Registry, [keys: :unique, name: @event_sourced_registry]}
          ]

        "cloudstate.action.ActionProtocol" ->
          []

        "cloudstate.crdt.Crdt" ->
          []
      end

    children =
      entities_childrens ++
        [
          {CloudState.EntityDiscoveryHandler, opts},

          # Last start GRPC Server
          {GRPC.Server.Supervisor,
           {CloudState.Endpoint,
            Application.fetch_env!(:cloudsate_elixir_support, :server_port) || 8080}}
        ]

    Supervisor.init(children, strategy: :one_for_one, name: __MODULE__)
  end
end
