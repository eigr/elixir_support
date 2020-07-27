defmodule CloudstateElixirSupportTest do
  use ExUnit.Case
  doctest CloudstateElixirSupport

  test "greets the world" do
    assert CloudstateElixirSupport.hello() == :world
  end
end
