defmodule Shoppingcart.AddLineItem do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: String.t(),
          product_id: String.t(),
          name: String.t(),
          quantity: integer
        }

  defstruct [:user_id, :product_id, :name, :quantity]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 11, 65, 100, 100, 76, 105, 110, 101, 73, 116, 101, 109, 18, 31, 10, 7, 117, 115, 101,
        114, 95, 105, 100, 24, 1, 32, 1, 40, 9, 66, 6, 24, 0, 40, 0, 80, 0, 82, 6, 117, 115, 101,
        114, 73, 100, 18, 29, 10, 10, 112, 114, 111, 100, 117, 99, 116, 95, 105, 100, 24, 2, 32,
        1, 40, 9, 82, 9, 112, 114, 111, 100, 117, 99, 116, 73, 100, 18, 18, 10, 4, 110, 97, 109,
        101, 24, 3, 32, 1, 40, 9, 82, 4, 110, 97, 109, 101, 18, 26, 10, 8, 113, 117, 97, 110, 116,
        105, 116, 121, 24, 4, 32, 1, 40, 5, 82, 8, 113, 117, 97, 110, 116, 105, 116, 121>>
    )
  end

  field(:user_id, 1, type: :string)
  field(:product_id, 2, type: :string)
  field(:name, 3, type: :string)
  field(:quantity, 4, type: :int32)
end

defmodule Shoppingcart.RemoveLineItem do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: String.t(),
          product_id: String.t()
        }

  defstruct [:user_id, :product_id]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 14, 82, 101, 109, 111, 118, 101, 76, 105, 110, 101, 73, 116, 101, 109, 18, 31, 10, 7,
        117, 115, 101, 114, 95, 105, 100, 24, 1, 32, 1, 40, 9, 66, 6, 24, 0, 40, 0, 80, 0, 82, 6,
        117, 115, 101, 114, 73, 100, 18, 29, 10, 10, 112, 114, 111, 100, 117, 99, 116, 95, 105,
        100, 24, 2, 32, 1, 40, 9, 82, 9, 112, 114, 111, 100, 117, 99, 116, 73, 100>>
    )
  end

  field(:user_id, 1, type: :string)
  field(:product_id, 2, type: :string)
end

defmodule Shoppingcart.GetShoppingCart do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user_id: String.t()
        }

  defstruct [:user_id]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 15, 71, 101, 116, 83, 104, 111, 112, 112, 105, 110, 103, 67, 97, 114, 116, 18, 31, 10,
        7, 117, 115, 101, 114, 95, 105, 100, 24, 1, 32, 1, 40, 9, 66, 6, 24, 0, 40, 0, 80, 0, 82,
        6, 117, 115, 101, 114, 73, 100>>
    )
  end

  field(:user_id, 1, type: :string)
end

defmodule Shoppingcart.LineItem do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          product_id: String.t(),
          name: String.t(),
          quantity: integer
        }

  defstruct [:product_id, :name, :quantity]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 8, 76, 105, 110, 101, 73, 116, 101, 109, 18, 29, 10, 10, 112, 114, 111, 100, 117, 99,
        116, 95, 105, 100, 24, 1, 32, 1, 40, 9, 82, 9, 112, 114, 111, 100, 117, 99, 116, 73, 100,
        18, 18, 10, 4, 110, 97, 109, 101, 24, 2, 32, 1, 40, 9, 82, 4, 110, 97, 109, 101, 18, 26,
        10, 8, 113, 117, 97, 110, 116, 105, 116, 121, 24, 3, 32, 1, 40, 5, 82, 8, 113, 117, 97,
        110, 116, 105, 116, 121>>
    )
  end

  field(:product_id, 1, type: :string)
  field(:name, 2, type: :string)
  field(:quantity, 3, type: :int32)
end

defmodule Shoppingcart.Cart do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          items: [Shoppingcart.LineItem.t()]
        }

  defstruct [:items]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 4, 67, 97, 114, 116, 18, 44, 10, 5, 105, 116, 101, 109, 115, 24, 1, 32, 3, 40, 11, 50,
        22, 46, 83, 104, 111, 112, 112, 105, 110, 103, 99, 97, 114, 116, 46, 76, 105, 110, 101,
        73, 116, 101, 109, 82, 5, 105, 116, 101, 109, 115>>
    )
  end

  field(:items, 1, repeated: true, type: Shoppingcart.LineItem)
end

defmodule Shoppingcart.ShoppingCart.Service do
  @moduledoc false
  use GRPC.Service, name: "Shoppingcart.ShoppingCart"

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.ServiceDescriptorProto.decode(
      <<10, 12, 83, 104, 111, 112, 112, 105, 110, 103, 67, 97, 114, 116, 18, 69, 10, 7, 65, 100,
        100, 73, 116, 101, 109, 18, 25, 46, 83, 104, 111, 112, 112, 105, 110, 103, 99, 97, 114,
        116, 46, 65, 100, 100, 76, 105, 110, 101, 73, 116, 101, 109, 26, 22, 46, 103, 111, 111,
        103, 108, 101, 46, 112, 114, 111, 116, 111, 98, 117, 102, 46, 69, 109, 112, 116, 121, 34,
        3, 136, 2, 0, 40, 0, 48, 0, 18, 75, 10, 10, 82, 101, 109, 111, 118, 101, 73, 116, 101,
        109, 18, 28, 46, 83, 104, 111, 112, 112, 105, 110, 103, 99, 97, 114, 116, 46, 82, 101,
        109, 111, 118, 101, 76, 105, 110, 101, 73, 116, 101, 109, 26, 22, 46, 103, 111, 111, 103,
        108, 101, 46, 112, 114, 111, 116, 111, 98, 117, 102, 46, 69, 109, 112, 116, 121, 34, 3,
        136, 2, 0, 40, 0, 48, 0, 18, 69, 10, 7, 71, 101, 116, 67, 97, 114, 116, 18, 29, 46, 83,
        104, 111, 112, 112, 105, 110, 103, 99, 97, 114, 116, 46, 71, 101, 116, 83, 104, 111, 112,
        112, 105, 110, 103, 67, 97, 114, 116, 26, 18, 46, 83, 104, 111, 112, 112, 105, 110, 103,
        99, 97, 114, 116, 46, 67, 97, 114, 116, 34, 3, 136, 2, 0, 40, 0, 48, 0>>
    )
  end

  rpc(:AddItem, Shoppingcart.AddLineItem, Google.Protobuf.Empty)

  rpc(:RemoveItem, Shoppingcart.RemoveLineItem, Google.Protobuf.Empty)

  rpc(:GetCart, Shoppingcart.GetShoppingCart, Shoppingcart.Cart)
end

defmodule Shoppingcart.ShoppingCart.Stub do
  @moduledoc false
  use GRPC.Stub, service: Shoppingcart.ShoppingCart.Service
end
