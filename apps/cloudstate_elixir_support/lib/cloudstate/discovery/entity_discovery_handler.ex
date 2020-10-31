defmodule CloudState.EntityDiscoveryHandler do
  use GenServer
  require Logger
  alias Protobuf.Encoder
  alias Cloudstate.{Entity, EntitySpec, ServiceInfo}

  @service_name Atom.to_string(Mix.Project.config()[:app])
  @service_vsn Mix.Project.config()[:version]
  @support_library_name "CloudState Elixir Support"
  @support_library_version Application.spec(:cloudstate_elixir_support, :vsn)
  @system_vsn elem(System.cmd("elixir", ["--version"]), 0)
  @default_description_path "priv/protos/shoppingcart/user-function.desc"

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
    entity_spec = proxy_info |> validate |> create_entity_spec(opts)
    {:reply, entity_spec, opts}
  end

  defp validate(proxy_info) do
    proxy_info
  end

  defp create_entity_spec(proxy_info, opts) do
    EntitySpec.new(
      proto: get_proto(opts),
      entities: create_entities(opts),
      service_info: get_service_info()
    )
  end

  defp get_service_info do
    ServiceInfo.new(
      service_name: get_service_name(),
      service_version: get_service_version(),
      service_runtime: get_service_runtime(),
      support_library_name: get_support_library_name(),
      support_library_version: get_support_library_version()
    )
  end

  defp get_service_name, do: @service_name
  defp get_service_runtime, do: @system_vsn
  defp get_service_version, do: @service_vsn
  defp get_support_library_name, do: @support_library_name
  defp get_support_library_version, do: @support_library_version
  defp get_service_name(service), do: service |> service_name

  defp create_entities(opts) do
    Logger.debug("Options #{inspect(opts)}")
    entity = opts.entity

    [
      Entity.new(
        entity_type: entity.get_entity_type(),
        service_name: get_service_name(opts.service),
        persistence_id: opts.persistence_id || Atom.to_string(opts.entity)
      )
    ]
  end

  defp get_proto(opts) do
    path = opts.file_description_path || @default_description_path
    result = File.read(path)
    elem(result, 1)
  end

  defp service_name(service) do
    module = service |> to_string() |> String.split(".") |> Enum.at(1)
    "#{module}.#{service.descriptor.name}"
  end
end
