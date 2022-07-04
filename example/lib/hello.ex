defmodule Hello do
  def add(a, b) do
    :hello_nif.add(a, b)
  end
end
