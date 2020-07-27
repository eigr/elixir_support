defmodule Cloudstate.EntityDiscovery.Server do
  use GRPC.Server, service: Cloudstate.EntityDiscovery.Service

  @spec discover(Cloudstate.ProxyInfo.t(), GRPC.Server.Stream.t()) :: Cloudstate.EntitySpec.t()
  def discover(request, _stream) do
    #
  end
end
