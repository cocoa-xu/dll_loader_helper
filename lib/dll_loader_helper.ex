defmodule DLLLoaderHelper do
  @moduledoc """
  DLL loader helper.
  """

  @doc """
  Add a directory to DLL search path for Windows.
  """
  @spec addDLLDirectory(binary()) :: :ok | {:error, String.t()}
  def addDLLDirectory(dir) when is_binary(dir) do
    case :os.type() do
      {:win32, _} -> :dll_loader_helper_nif.addDLLDirectory(dir)
      _ -> :ok
    end
  end
end
