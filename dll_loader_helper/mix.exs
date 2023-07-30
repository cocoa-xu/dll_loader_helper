defmodule DllLoaderHelper.MixProject do
  use Mix.Project

  @app :dll_loader_helper
  @github_url "https://github.com/cocoa-xu/dll_loader_helper/tree/main/dll_loader_helper"
  @version "1.1.0"
  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      source_url: @github_url,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:dll_loader_helper_beam, "~> 1.1"},
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
      files: ~w(mix.exs lib .formatter.exs README* LICENSE*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @github_url}
    ]
  end
end
