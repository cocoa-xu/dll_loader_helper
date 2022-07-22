-module(dll_loader_helper).
-export([add_dll_directory/1]).
-on_load(init/0).

-define(APPNAME, dll_loader_helper).
-define(LIBNAME, dll_loader_helper).

add_dll_directory(_) ->
    case os:type() of
        {win32, _} -> not_loaded(?LINE);
        _ -> ok
    end.

init() ->
    case os:type() of
        {win32, _} ->
             SoName = case code:priv_dir(?APPNAME) of
                {error, bad_name} ->
                    case filelib:is_dir(filename:join(["..", priv])) of
                        true ->
                            filename:join(["..", priv, ?LIBNAME]);
                        _ ->
                            filename:join([priv, ?LIBNAME])
                    end;
                Dir ->
                    filename:join(Dir, ?LIBNAME)
            end,
            erlang:load_nif(SoName, 0);
        _ ->
            ok
    end.

not_loaded(Line) ->
    erlang:nif_error({not_loaded, [{module, ?MODULE}, {line, Line}]}).

