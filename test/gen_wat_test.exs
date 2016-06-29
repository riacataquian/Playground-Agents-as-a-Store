defmodule GenWatTest do
  use ExUnit.Case
  doctest GenWat

  test "the truth" do
    {:ok, pid} = GenWat.start_link

    GenWat.add(pid, 10)

    assert GenWat.state(pid) == 10

    GenWat.add(pid, 1)
    assert GenWat.state(pid) == 11
  end
end
