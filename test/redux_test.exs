defmodule ReduxTest do
  use ExUnit.Case

  def reducer(state, action) do
    case action.type do
      :set ->
        action.value
      :add ->
        state + action.value
      _ ->
        state
    end
  end

  test "Redux.state/1 returns current state" do
    pid = Redux.create_store(&reducer/2)

    Redux.dispatch(pid, %{type: :set, value: 2})
    assert Redux.get_state(pid) == 2
  end

  test "Redux.dispatch/2 sets state to value passed if type is :set" do
    pid = Redux.create_store(&reducer/2)

    Redux.dispatch(pid, %{type: :set, value: 2})
    assert Redux.get_state(pid) == 2
  end

  test "Redux.dispatch/2 adds current to value passed if type is :add" do
    pid = Redux.create_store(&reducer/2)

    Redux.dispatch(pid, %{type: :set, value: 2})
    Redux.dispatch(pid, %{type: :add, value: 4})
    assert Redux.get_state(pid) == 6
  end
end

