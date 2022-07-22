defmodule DLLLoaderHelper do
  @moduledoc """
  DLL loader helper.
  """

  @doc """
  Add a directory to DLL search path for Windows.
  """
  @spec addDLLDirectory(binary()) :: :ok | {:error, String.t()}
  def addDLLDirectory(dir) when is_binary(dir) do
    :dll_loader_helper.add_dll_directory(dir)
  end
end
