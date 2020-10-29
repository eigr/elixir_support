defmodule CloudState.EntityDiscoveryHandler do
  use GenServer
  require Logger
  alias Cloudstate.{EntitySpec, ServiceInfo}

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :transient
    }
  end

  # Client functions
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def discover(proxy_info) do
    GenServer.call(__MODULE__, {:discover, proxy_info})
  end

  # Server callbacks

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def handle_call({:discover, proxy_info}, _from, opts) do
    entity_spec = proxy_info |> validate |> create_entity_spec
    {:reply, entity_spec, opts}
  end

  defp validate(proxy_info) do
    proxy_info
  end

  defp create_entity_spec(proxy_info) do
    EntitySpec.new(proto: nil, entities: nil, service_info: nil)
  end
end
