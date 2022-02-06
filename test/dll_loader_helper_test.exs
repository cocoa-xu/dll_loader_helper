defmodule DLLLoaderHelperTest do
  use ExUnit.Case

  case :os.type() do
    {:win32, _} ->
      :ok

    _ ->
      test "is a no-op on Unix" do
        assert DLLLoaderHelper.addDLLDirectory("example") == :ok
      end
  end
end
