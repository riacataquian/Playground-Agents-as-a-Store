defmodule Example do
  import Redux

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

  def run do
    create_store(&reducer/2)
    |> dispatch(%{type: :set, value: 2})
    |> get_state()
    |> IO.puts()

    create_store(&reducer/2)
    |> dispatch(%{type: :set, value: 2})
    |> dispatch(%{type: :add, value: 10})
    |> get_state()
    |> IO.puts() # 12
  end
end

Example.run

