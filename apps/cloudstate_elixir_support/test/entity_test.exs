defmodule CloudState.EventSourcedTest do
  use ExUnit.Case
  require Logger

  defmodule ShoppingCart do
    use CloudState.EventSourced
  end

  test "ShoppingCart handle_snapshot init state" do
    # init_state =
    #  Domain.Cart.new(
    #    items: [
    #      Domain.LineItem.new(productId: "1", name: "Led Zeppelin - No Quarter", quantity: 1)
    #    ]
    #  )

    # ShoppingCart.handle_snapshot(init_state)

    # assert ShoppingCart.snapshot == [%Shoppingcart.LineItem{name: "Led Zeppelin - No Quarter", product_id: "1", quantity: 1}]
    # assert ShoppingCart.state() == %{}
  end
end
