defmodule :dll_loader_helper_nif do
  @moduledoc false
  @on_load :load_nif
  def load_nif do
    require Logger
    nif_file = '#{:code.priv_dir(:dll_loader_helper)}/dll_loader_helper'

    case :erlang.load_nif(nif_file, 0) do
      :ok -> :ok
      {:error, {:reload, _}} -> :ok
      {:error, reason} -> Logger.warn("Failed to load nif: #{inspect(reason)}")
    end
  end

  def addDLLDirectory(_dir), do: :erlang.nif_error(:not_loaded)
end
