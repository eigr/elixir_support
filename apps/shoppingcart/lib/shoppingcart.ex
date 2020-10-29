defmodule Shoppingcart.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {CloudState.Supervisor,
       %{
         entity: ShoppingCart.Entity,
         service_descriptor: Shoppingcart.ShoppingCart.Service,
         domain_descriptors: [Domain.LineItem, Domain.ItemAdded, Domain.ItemRemoved, Domain.Cart]
       }}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
