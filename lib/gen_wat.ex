defmodule GenWat do
  use GenServer

  @doc """
  Starts the registry.
  """
  def start_link(initial_state \\ 0) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  # SERVER CALLBACKS
  def handle_call(:pop, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:add, new_state}, old_state) do
    {:noreply, new_state + old_state}
  end

  @doc """
  Cast new value to the current state.

  ## Examples:

      iex> {:ok, pid} = GenWat.start_link()
      iex> GenWat.add(pid, 10)
      :ok
      iex> GenWat.add(pid, 20)
      :ok
      iex> GenWat.state(pid)
      30
  """
  def add(pid, num \\ 0), do: GenServer.cast(pid, {:add, num})

  def state(pid), do: GenServer.call(pid, :pop)
end
