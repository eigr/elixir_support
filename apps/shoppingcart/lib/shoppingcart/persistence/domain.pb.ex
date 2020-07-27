defmodule Domain.LineItem do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          productId: String.t(),
          name: String.t(),
          quantity: integer
        }

  defstruct [:productId, :name, :quantity]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 8, 76, 105, 110, 101, 73, 116, 101, 109, 18, 28, 10, 9, 112, 114, 111, 100, 117, 99,
        116, 73, 100, 24, 1, 32, 1, 40, 9, 82, 9, 112, 114, 111, 100, 117, 99, 116, 73, 100, 18,
        18, 10, 4, 110, 97, 109, 101, 24, 2, 32, 1, 40, 9, 82, 4, 110, 97, 109, 101, 18, 26, 10,
        8, 113, 117, 97, 110, 116, 105, 116, 121, 24, 3, 32, 1, 40, 5, 82, 8, 113, 117, 97, 110,
        116, 105, 116, 121>>
    )
  end

  field(:productId, 1, type: :string)
  field(:name, 2, type: :string)
  field(:quantity, 3, type: :int32)
end

defmodule Domain.ItemAdded do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          item: Domain.LineItem.t() | nil
        }

  defstruct [:item]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 9, 73, 116, 101, 109, 65, 100, 100, 101, 100, 18, 36, 10, 4, 105, 116, 101, 109, 24,
        1, 32, 1, 40, 11, 50, 16, 46, 68, 111, 109, 97, 105, 110, 46, 76, 105, 110, 101, 73, 116,
        101, 109, 82, 4, 105, 116, 101, 109>>
    )
  end

  field(:item, 1, type: Domain.LineItem)
end

defmodule Domain.ItemRemoved do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          productId: String.t()
        }

  defstruct [:productId]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 11, 73, 116, 101, 109, 82, 101, 109, 111, 118, 101, 100, 18, 28, 10, 9, 112, 114, 111,
        100, 117, 99, 116, 73, 100, 24, 1, 32, 1, 40, 9, 82, 9, 112, 114, 111, 100, 117, 99, 116,
        73, 100>>
    )
  end

  field(:productId, 1, type: :string)
end

defmodule Domain.Cart do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          items: [Domain.LineItem.t()]
        }

  defstruct [:items]

  def descriptor do
    # credo:disable-for-next-line
    Elixir.Google.Protobuf.DescriptorProto.decode(
      <<10, 4, 67, 97, 114, 116, 18, 38, 10, 5, 105, 116, 101, 109, 115, 24, 1, 32, 3, 40, 11, 50,
        16, 46, 68, 111, 109, 97, 105, 110, 46, 76, 105, 110, 101, 73, 116, 101, 109, 82, 5, 105,
        116, 101, 109, 115>>
    )
  end

  field(:items, 1, repeated: true, type: Domain.LineItem)
end
