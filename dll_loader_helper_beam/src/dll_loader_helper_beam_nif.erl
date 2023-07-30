-module(dll_loader_helper_beam_nif).
-compile(nowarn_export_all).
-compile([export_all]).
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-on_load(init/0).

-define(APPNAME, dll_loader_helper_beam).
-define(LIBNAME, dll_loader_helper_beam).

init() ->
    case os:type() of
        {win32, nt} ->
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


add_dll_directory(_DllDirectory) ->
    not_loaded(?LINE).

-ifdef(EUNIT).
add_dll_directory_test() ->
    case os:type() of
        {win32, nt} ->
            ?assertEqual(add_dll_directory("C:/"), ok);
        _ ->
            true
    end.
-endif.
