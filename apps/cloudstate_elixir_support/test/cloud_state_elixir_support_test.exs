defmodule CloudStateElixirSupportTest do
  use ExUnit.Case
  # doctest CloudStateElixirSupport

  defmodule ShoppingCart do
    use CloudState.EventSourced
  end

  test "ShoppingCart should contain single annotation if registered" do
    # assert ShoppingCart.annotations().add == [
    #         %{
    #           annotation: :command,
    #           value: %{
    #             name: AddItem,
    #             type: Shoppingcart.AddLineItem
    #           }
    #         },
    #         %{
    #           annotation: :command,
    #           value: %{
    #             name: AddItem,
    #             result: Google.Protobuf.Empty,
    #             type: Shoppingcart.AddLineItem
    #           }
    #         }
    #       ]
  end
end
