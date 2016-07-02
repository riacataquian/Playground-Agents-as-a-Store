defmodule Redux do
  @moduledoc """
  Like redux.js, but more Elixir-like
  """

  defstruct reducer: nil, state: nil, subscribers: []

  @doc """
  Creates a store. Accepts two optional parameters, the `initial state` and the `reducer`.

  `initial state` defaults to 0.

  `reducer` defaults to nil.

  Returns the PID of the store.

  """
  def create_store(initial_state \\ 0, reducer) do
    {:ok, store} = Agent.start_link(fn -> %Redux{reducer: reducer, state: initial_state} end)

    store
  end

  @doc """

  Returns the state of the store.

  """
  def get_state(store) do
    Agent.get(store, &(&1.state))
  end

  @doc """
  Dispatches an action. Accepts two parameter, the `store's PID` and `reducer`.
  """
  def dispatch(store, action) do
    state = get_state(store)

    with :ok <- Agent.update(store, fn store_map -> %{ store_map | state: store_map.reducer.(state, action)} end),
      do: broadcast(store)

    store
  end

  defp broadcast(store) do
    store
    |> subscribers()
    |> Enum.each(&(&1.(store)))
  end

  @doc """
  Accepts a store and a function. Appends the passed function in the Redux struct `subscribers`.

  Returns a tuple with the unsubscribe function.

  """
  def subscribe(store, fun) when is_function(fun) do
    Agent.update(store, fn store_map -> %{ store_map | subscribers: [ fun | store_map.subscribers ] } end)

    {:ok, fn -> unsubscribe(store,fun) end}
  end

  def subscribe(_store, _fun), do: raise "Please pass a function instead"

  @doc """
  When invoked, unsubscribes the subscriber and returns the remaining subscribers.
  """
  def unsubscribe(store, subscriber) do
    Agent.update(store, fn store_map -> %{ store_map | subscribers: List.delete(store_map.subscribers, subscriber)} end)

    subscribers(store)
  end

  def subscribers(store) do
    Agent.get(store, &(&1.subscribers))
  end
end

