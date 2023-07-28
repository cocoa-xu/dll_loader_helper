-module(dll_loader_helper_beam).
-export([add_dll_directory/1]).

add_dll_directory(DllDirectory) ->
    case os:type() of
        {win32, nt} ->
            dll_loader_helper_beam_nif:add_dll_directory(DllDirectory);
        _ ->
            ok
    end.
