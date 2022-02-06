defmodule DLLLoaderHelper do
  @moduledoc """
  DLL loader helper.
  """

  @on_load :load_nif
  def load_nif do
    case :os.type() do
      {:win32, _} ->
        nif_file = '#{:code.priv_dir(:dll_loader_helper)}/dll_loader_helper'

        case :erlang.load_nif(nif_file, 0) do
          :ok -> :ok
          {:error, {:reload, _}} -> :ok
          {:error, reason} -> {:error, reason}
        end

      _ ->
        :ok
    end
  end

  @doc """
  Add a directory to DLL search path for Windows.
  """
  @spec addDLLDirectory(binary()) :: :ok | {:error, String.t()}
  def addDLLDirectory(dir) when is_binary(dir) do
    :ok
  end
end
