defmodule Shoppingcart.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {CloudState.Supervisor, %{}}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
