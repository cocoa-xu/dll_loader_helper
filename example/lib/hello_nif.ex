defmodule :hello_nif do
  @on_load :load_nif
  def load_nif do
    :ok =
      case :os.type do
        {:win32, _} -> DLLLoaderHelper.addDLLDirectory("#{:code.priv_dir(:hello)}/lib")
        _ -> :ok
      end
    nif_file = '#{:code.priv_dir(:hello)}/hello_nif'

    case :erlang.load_nif(nif_file, 0) do
      :ok -> :ok
      {:error, {:reload, _}} -> :ok
      {:error, reason} -> IO.puts("Failed to load nif: #{inspect(reason)}")
    end
  end

  def add(_a, _b), do: :erlang.nif_error(:not_loaded)
end
