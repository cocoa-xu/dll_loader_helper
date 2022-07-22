-module(dll_loader_helper).
-export([add_dll_directory/1]).

add_dll_directory(Path) ->
    add_dll_directory_nif:add_dll_directory(Path).
