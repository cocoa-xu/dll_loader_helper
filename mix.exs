defmodule Mix.Tasks.Compile.DllLoaderHelper do
  use Mix.Task

  @windows_error_msg ~S"""
  One option is to install a recent version of
  [Visual C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)
  either manually or using [Chocolatey](https://chocolatey.org/) -
  `choco install VisualCppBuildTools`.
  After installing Visual C++ Build Tools, look in the "Program Files (x86)"
  directory and search for "Microsoft Visual Studio". Note down the full path
  of the folder with the highest version number. Open the "run" command and
  type in the following command (make sure that the path and version number
  are correct):
      cmd /K "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
  This should open up a command prompt with the necessary environment variables
  set, and from which you will be able to run the "mix compile", "mix deps.compile",
  and "mix test" commands.
  Another option is to install the Linux compatiblity tools from [MSYS2](https://www.msys2.org/).
  After installation start the msys64 bit terminal from the start menu and install the
  C/C++ compiler toolchain. E.g.:
    pacman -S --noconfirm pacman-mirrors pkg-config
    pacman -S --noconfirm --needed base-devel autoconf automake make libtool git \
      mingw-w64-x86_64-toolchain mingw-w64-x86_64-openssl mingw-w64-x86_64-libtool
  This will give you a compilation suite nearly compatible with Unix' standard tools.
  """
  def run(_) do
    case :os.type() do
      {:win32, _} ->
        root_dir = :code.root_dir()
        erts_dir = Path.join(root_dir, "erts-#{:erlang.system_info(:version)}")
        erts_include_dir = System.get_env("ERTS_INCLUDE_DIR", Path.join(erts_dir, "include"))
        System.put_env("ERTS_INCLUDE_DIR", erts_include_dir)
        System.put_env("MIX_APP_PATH", Mix.Project.app_path())

        opts = [
          into: IO.stream(:stdio, :line),
          stderr_to_stdout: true,
          cd: Path.expand(File.cwd!()),
        ]

        Mix.Project.ensure_structure()
        {%IO.Stream{}, status} = System.cmd("nmake", ["/F", "Makefile.win"], opts)
        Mix.Project.ensure_structure()

        case status do
          0 -> :ok
          _ ->
            Mix.raise(~s{Could not compile with nmake" (exit status: #{status}).\n} <> @windows_error_msg)
        end

      _ -> :ok
    end
  end
end

defmodule DllLoaderHelper.MixProject do
  use Mix.Project

  @app :dll_loader_helper
  @github_url "https://github.com/cocoa-xu/dll_loader_helper"
  def project do
    [
      app: @app,
      version: "0.1.7",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [@app] ++ Mix.compilers(),
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
