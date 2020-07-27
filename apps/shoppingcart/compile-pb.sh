#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

# CloudState Protocol
protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos/ priv/protos/cloudstate/entity_key.proto
protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos/ priv/protos/google/api/annotations.proto
protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos/ priv/protos/google/api/http.proto
protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos/ priv/protos/google/api/httpbody.proto

protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos priv/protos/shoppingcart/persistence/domain.proto
protoc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos priv/protos/shoppingcart/shoppingcart.proto
