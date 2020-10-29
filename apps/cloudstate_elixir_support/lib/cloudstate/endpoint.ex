defmodule CloudState.Endpoint do
  use GRPC.Endpoint

  intercept(GRPC.Logger.Server)

  run([
    CloudState.EntityDiscovery.Server
  ])
end
