defmodule CloudState.EntityDiscovery.Server do
  use GRPC.Server, service: Cloudstate.EntityDiscovery.Service
  require Logger
  alias CloudState.EntityDiscoveryHandler

  @spec discover(Cloudstate.ProxyInfo.t(), GRPC.Server.Stream.t()) :: Cloudstate.EntitySpec.t()
  def discover(proxy_info, _stream) do
    Logger.info('Received discover request from Proxy:\n #{inspect(proxy_info)}')
    EntityDiscoveryHandler.discover(proxy_info)
  end
end
