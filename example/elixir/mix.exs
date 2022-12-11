defmodule Hello.MixProject do
  use Mix.Project

  def project do
    parent_project = Path.expand(Path.join([Path.dirname(__ENV__.file), "../../"]))
    IO.puts(parent_project)
    [
      app: :hello,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      compilers: [:elixir_make] ++ Mix.compilers(),
      deps: [
        {:elixir_make, ">= 0.0.0", github: "elixir-lang/elixir_make", override: true},
        {:dll_loader_helper, "~> 0.1", path: parent_project}
      ]
    ]
  end
end
