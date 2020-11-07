defmodule ShoppingCart.Entity do
  use CloudState.EventSourced
  alias Google.Protobuf.Empty

  @impl true
  def init(state), do: {:ok, state}

  @impl true
  def handle_event(:item_added, _request, _state) do
    # TODO: Do something and generate new_state
    new_state = %{}
    {:ok, new_state}
  end

  @impl true
  def handle_command(:get_cart, _request, state) do
    # TODO: Use state to create items in response
    items = Shoppingcart.Cart.new(items: [])
    {:ok, items, state}
  end

  @impl true
  def handle_command(:add_item, request, state) do
    if request.quantity <= 0 do
      {:error, "Cannot add negative quantity of to item #{request.product_id}", state}
    else
      item =
        Domain.ItemAdded.new(
          item:
            Domain.LineItem.new(
              productId: request.product_id,
              name: request.name,
              quantity: request.quantity
            )
        )

      {:emit, item, Empty.new(), state}
    end
  end
end
