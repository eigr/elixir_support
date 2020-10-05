defmodule CloudstateElixirSupportTest do
  use ExUnit.Case
  doctest CloudstateElixirSupport

  defmodule Example do
    use Cloudstate.EventSourced

    @command true
    def bar_method do end

    @event [:test]
    @command true
    def foo_bar_method do end

    def no_annotation_method do end

    @baz "ads"
    def undefined_annotation_method do end
  end

  test "Example should contain single annotation if registered" do
    assert Example.annotations.bar_method == [%{annotation: :command, value: true}]
  end

  test "Example should contain multipule annotations if registered" do
    assert Example.annotations.foo_bar_method == [%{annotation: :command, value: true},%{annotation: :event, value: [:test]}]
  end

  test "Example should not contain annotations if undefined annotation on method" do
    assert Example.annotations |> Map.has_key?(:undefined_annotation_method) == false
  end

  test "Example should not contain annotations in no annotations on method" do
    assert Example.annotations |> Map.has_key?(:no_annotation_method) == false
  end

  test "Example get methods annotated with command" do
    assert Example.annotated_with(:command) == [:bar_method, :foo_bar_method]
  end
end
