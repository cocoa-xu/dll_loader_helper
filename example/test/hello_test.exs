defmodule HelloTest do
  use ExUnit.Case

  test "do add in shared library" do
    assert Hello.add(1, 2) == 3
  end
end
