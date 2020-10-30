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
#protoc --include_imports --descriptor_set_out=priv/protos/shoppingcart/user-function.desc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos priv/protos/shoppingcart/shoppingcart.proto
protoc --include_imports --descriptor_set_out=priv/protos/shoppingcart/user-function.desc --elixir_out=gen_descriptors=true,plugins=grpc:./lib --proto_path=priv/protos -I priv/protos/shoppingcart/persistence/domain.proto priv/protos/shoppingcart/shoppingcart.proto



protoc --include_imports --descriptor_set_out=user-function.desc -I protos/persistence/domain.proto protos/shoppingcart.proto --dart_out=grpc:lib/src/generated