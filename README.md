# DLLLoaderHelper

[![windows-x86_64](https://github.com/cocoa-xu/dll_loader_helper/actions/workflows/windows-x86_64.yml/badge.svg)](https://github.com/cocoa-xu/dll_loader_helper/actions/workflows/windows-x86_64.yml)

Add a directory to DLL search path for Windows. 

Say you are building a library, `:library_name`, which loads some 3rd party shared libraries from
`:code.priv_dir(:library_name)/lib`. It's quite easy to add rpath on *nix systems, but we don't really have
rpath in Windows. 

Therefore, we have to use [`AddDllDirectory`](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-adddlldirectory) to manually add the directory that contains these
.dll files to the search path.

## Usage

### Erlang
```erlang
ok = 
  case os:type() of
    {:win32, _} -> dll_loader_helper:add_dll_directory('...')
    _ -> ok
  end
```

A complete Erlang example available in [example/erlang](example/erlang).

### Elixir
```elixir
:ok = 
  case :os.type do
    {:win32, _} -> DLLLoaderHelper.addDLLDirectory("#{:code.priv_dir(:library_name)}/lib")
    _ -> :ok
  end
```

Note that calling `dll_loader_helper:add_dll_directory/1` or `DLLLoaderHelper.addDLLDirectory/1` on *nix systems will NOT have any effect, and `:ok` will be returned.

A complete Elixir example available in [example/elixir](example/elixir).

## Installation

### Rebar3

```erlang
{deps, [
  {dll_loader_helper, "0.1.7"},
]}.
```

### Mix

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dll_loader_helper` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dll_loader_helper, "~> 0.1.7"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/dll_loader_helper>.

