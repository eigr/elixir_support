defmodule CloudStateElixirSupportTest do
  use ExUnit.Case
  doctest CloudstateElixirSupport

  defmodule ShoppingCart do
    use Cloudstate.EventSourced

    @command true
    def add_item do end

    @event [:test]
    @command true
    def item_added do end

    def convert do end

    @baz "ads"
    def undefined_annotation_method do end
  end

  test "ShoppingCart should contain single annotation if registered" do
    assert ShoppingCart.annotations.add_item == [%{annotation: :command, value: true}]
  end

  test "ShoppingCart should contain multipule annotations if registered" do
    assert ShoppingCart.annotations.item_added == [%{annotation: :command, value: true},%{annotation: :event, value: [:test]}]
  end

  test "ShoppingCart should not contain annotations if undefined annotation on method" do
    assert ShoppingCart.annotations |> Map.has_key?(:undefined_annotation_method) == false
  end

  test "ShoppingCart should not contain annotations in no annotations on method" do
    assert ShoppingCart.annotations |> Map.has_key?(:convert) == false
  end

  test "ShoppingCart get methods annotated with command" do
    assert ShoppingCart.annotated_with(:command) == [:add_item, :item_added]
  end
end
