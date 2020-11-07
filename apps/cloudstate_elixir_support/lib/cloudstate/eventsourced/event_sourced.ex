defmodule CloudState.EventSourced do
  defmacro __using__(_args) do
    quote do
      @behaviour CloudState.EventSourced
      @entity_type "cloudstate.eventsourced.EventSourced"
      @before_compile {unquote(__MODULE__), :__before_compile__}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def get_entity_type, do: @entity_type
    end
  end

  @callback init(state :: term) :: {:ok, new_state :: term} | {:error, reason :: term}

  @callback handle_command(service :: term, request :: term, state :: term) ::
              {:ok, result :: term, state :: term}
              | {:emit, event :: term, result :: term, state :: term}
              | {:emit, event :: term, forward :: term, result :: term, state :: term}
              | {:error, reason :: term, state :: term}

  @callback handle_event(event_type :: term, request :: term, state :: term) ::
              {:ok, new_state :: term}
              | {:error, reason :: term, state :: term}
end
