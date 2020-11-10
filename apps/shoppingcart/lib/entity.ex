defmodule ShoppingCart.Entity do
  use CloudState.EventSourced
  alias Google.Protobuf.Empty

  @impl true
  @spec init(%{state: any}) :: {:ok, %{state: %{}}}
  def init(context), do: {:ok, %{context | state: %{}}}

  @impl true
  @spec handle_event(:item_added, any, any) :: {:ok, %{}}
  def handle_event(:item_added, _request, _context) do
    # TODO: Do something and generate context_with_state
    context_with_state = %{}
    {:ok, context_with_state}
  end

  @impl true
  @spec handle_command(:add_item | :get_cart, any, any) ::
          {:error, <<_::64, _::_*8>>, any} | {:ok, any, any}
  def handle_command(:get_cart, _request, context) do
    # TODO: Use context.state to create items in response
    items =
      Shoppingcart.Cart.new(
        items: [Shoppingcart.LineItem.new(product_id: "1", name: "Led Zeppelin", quantity: 10)]
      )

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

      {:ok, Empty.new(), %{context | events: [item]}}
    end
  end
end
