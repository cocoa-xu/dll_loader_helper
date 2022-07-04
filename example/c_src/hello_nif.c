#include <erl_nif.h>

int add(int a, int b);

static ERL_NIF_TERM add_nif(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    if (argc != 2) {
        return enif_make_badarg(env);
    }

    int a;
    int b;
    if (enif_get_int(env, argv[0], &a) && enif_get_int(env, argv[1], &b)) {
        return enif_make_int(env, add(a, b));
    } else {
        return enif_make_badarg(env);
    }
}

static int on_load(ErlNifEnv* env, void** _priv_data, ERL_NIF_TERM unused) {
    return 0;
}

static int on_reload(ErlNifEnv* env, void** _priv_data, ERL_NIF_TERM unused) {
    return 0;
}

static int on_upgrade(ErlNifEnv* env, void** old_priv_data, void** new_priv_data , ERL_NIF_TERM unused) {
    return 0;
}

static ErlNifFunc nif_funcs[] = {
    {"add", 2, &add_nif}
};

ERL_NIF_INIT(hello_nif, nif_funcs, on_load, on_reload, on_upgrade, NULL);
