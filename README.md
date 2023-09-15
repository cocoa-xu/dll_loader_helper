# dll_loader_helper_beam

[![windows](https://github.com/cocoa-xu/dll_loader_helper/actions/workflows/windows.yml/badge.svg)](https://github.com/cocoa-xu/dll_loader_helper/actions/workflows/windows.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/dll_loader_helper.svg?style=flat&color=blue)](https://hex.pm/packages/dll_loader_helper)

Add a directory to DLL search path for Windows. 

Say you are building a library, `library_name`, which loads some 3rd party shared libraries from
`code:priv_dir(library_name)/lib`. It's quite easy to add rpath on *nix systems, but we don't really have rpath in Windows. 

Therefore, we have to use [`AddDllDirectory`](https://docs.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-adddlldirectory) to manually add the directory that contains these
.dll files to the search path.

## Usage

```erlang
:ok = 
  case os:type() of
    {win32, nt} -> dll_loader_helper_beam:add_dll_directory("/SOME/DIRECTORY")
    _ -> ok
  end
```

Note that calling `dll_loader_helper_beam:add_dll_directory/1` on *nix systems will NOT have any effect, and `ok` will be returned.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dll_loader_helper` to your list of dependencies in `mix.exs`:

```erlang
{deps, [
  dll_loader_helper
]}.
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/dll_loader_helper_beam>.

