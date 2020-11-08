defmodule ShoppingCart.Entity do
  use CloudState.EventSourced
  alias Google.Protobuf.Empty

  @impl true
  def init(context), do: {:ok, %{context | state: %{}}}

  @impl true
  def handle_event(:item_added, _request, _context) do
    # TODO: Do something and generate context_with_state
    context_with_state = %{}
    {:ok, context_with_state}
  end

  @impl true
  def handle_command(:get_cart, _request, context) do
    # TODO: Use context.state to create items in response
    items = Shoppingcart.Cart.new(items: [])
    {:ok, items, context}
  end

  @impl true
  def handle_command(:add_item, request, context) do
    if request.quantity <= 0 do
      {:error, "Cannot add negative quantity of to item #{request.product_id}", context}
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

      {:emit, item, Empty.new(), context}
    end
  end
end
