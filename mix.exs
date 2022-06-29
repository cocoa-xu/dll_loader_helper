defmodule DllLoaderHelper.MixProject do
  use Mix.Project

  @github_url "https://github.com/cocoa-xu/dll_loader_helper"
  def project do
    [
      app: :dll_loader_helper,
      version: "0.1.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: compilers() ++ Mix.compilers(),
      source_url: @github_url,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp compilers() do
    case :os.type() do
      {:win32, _} -> [:elixir_make]
      _ -> []
    end
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.6", runtime: false},
      {:ex_doc, "~> 0.28", only: :docs, runtime: false}
    ]
  end

  defp description() do
    "Add a directory to dynamic DLL search path on Windows."
  end

  defp package() do
    [
      name: "dll_loader_helper",
      # These are the default files included in the package
      files:
        ~w(lib c_src .formatter.exs mix.exs README* LICENSE* Makefile.win src rebar.config),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
