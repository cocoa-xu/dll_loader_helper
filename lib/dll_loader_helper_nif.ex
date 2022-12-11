defmodule :dll_loader_helper do
  @moduledoc false

  @on_load :load_nif
  def load_nif do
    case :os.type() do
      {:win32, _} ->
        nif_file = ~c"#{:code.priv_dir(:dll_loader_helper)}/dll_loader_helper"

        case :erlang.load_nif(nif_file, 0) do
          :ok -> :ok
          {:error, {:reload, _}} -> :ok
          {:error, reason} -> IO.puts("Failed to load nif: #{reason}")
        end

      _ ->
        :ok
    end
  end

  def add_dll_directory(_dir) do
    case :os.type() do
      {:win32, _} -> :erlang.nif_error(:not_loaded)
      _ -> :ok
    end
  end
end
