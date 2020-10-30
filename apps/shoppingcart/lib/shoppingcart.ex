defmodule Shoppingcart.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {CloudState.Supervisor,
       %{
         name: "shoppingcart",
         entity: ShoppingCart.Entity,
         persistence_id: "shoppincart",
         service: Shoppingcart.ShoppingCart.Service,
         file_description_path: "priv/protos/shoppingcart/user-function.desc"
       }}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
