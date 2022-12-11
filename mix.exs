defmodule DllLoaderHelper.MixProject do
  use Mix.Project

  @app :dll_loader_helper
  @github_url "https://github.com/cocoa-xu/dll_loader_helper"
  @version "0.1.8"
  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [:elixir_make] ++ Mix.compilers(),
      source_url: @github_url,
      description: description(),
      package: package(),
      deps: deps(),
      make_precompiler: {:nif, CCPrecompiler},
      make_precompiler_filename: "dll_loader_helper",
      make_precompiler_url: "#{@github_url}/releases/download/v#{@version}/@{artefact_filename}",
      cc_precompiler: [
        only_listed_targets: true,
        compilers: %{
          {:win32, :nt} => %{
            "x86_64-windows-msvc" => {"cl", "cl"}
          }
        }
      ]
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:cc_precompiler, "~> 0.1", runtime: false, github: "cocoa-xu/cc_precompiler"},
      {:elixir_make, ">= 0.0.0", github: "elixir-lang/elixir_make", override: true},
      {:ex_doc, "~> 0.28", only: :docs, runtime: false}
    ]
  end

  defp description() do
    "Add a directory to dynamic DLL search path on Windows."
  end

  defp package() do
    [
      name: to_string(@app),
      # These are the default files included in the package
      files:
        ~w(c_src CMakeLists.txt Makefile.win
           mix.exs lib src rebar.config .formatter.exs
           README* LICENSE*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
