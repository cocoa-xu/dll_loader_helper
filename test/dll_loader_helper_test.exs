defmodule DLLLoaderHelperTest do
  use ExUnit.Case

  case :os.type() do
    {:win32, _} ->
      test "add dll directory on windows" do
        DLLLoaderHelper.addDLLDirectory("#{:code.priv_dir(:dll_loader_helper)}") == :ok
      end

    _ ->
      test "is a no-op on Unix" do
        assert DLLLoaderHelper.addDLLDirectory("example") == :ok
      end
  end
end
