defmodule ShoppingCart.Entity do
  use CloudState.EventSourced

  @command true
  def add_item do
  end

  @event [:test]
  def item_added do
  end

  defp convert do
  end
end
