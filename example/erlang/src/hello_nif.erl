-module(hello_nif).
-export([add/2]).
-on_load(init/0).

-define(APPNAME, hello).
-define(LIBNAME, hello).

add(_, _) ->
    not_loaded(?LINE).

init() ->
    PrivDir = code:priv_dir(?APPNAME),
    PrivLibDir = filename:join(PrivDir, lib),
    ok = 
        case os:type() of
            {win32, _} ->
                dll_loader_helper:add_dll_directory(PrivLibDir);
            _ ->
                ok
        end,
    SoName = filename:join(PrivDir, hello_nif),
    erlang:load_nif(SoName, 0).

not_loaded(Line) ->
    erlang:nif_error({not_loaded, [{module, ?MODULE}, {line, Line}]}).

