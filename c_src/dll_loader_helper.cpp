#include <erl_nif.h>
#include <string>
#include "nif_utils.hpp"

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
#include <windows.h>
#include <libloaderapi.h>
#include <winbase.h>
#include <wchar.h>

#ifdef __cplusplus
extern "C"
{
#endif
	static ERL_NIF_TERM dll_loader_helper_addDLLDirectory(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
		if (argc != 1) return enif_make_badarg(env);

		std::string newDirectory;
		if (erlang::nif::get(env, argv[0], newDirectory)) {
			int len;
			int slen = (int)newDirectory.length() + 1;
			len = MultiByteToWideChar(CP_ACP, 0, newDirectory.c_str(), slen, 0, 0);
			wchar_t* buf = new wchar_t[len];
			MultiByteToWideChar(CP_ACP, 0, newDirectory.c_str(), slen, buf, len);
			std::wstring newDirectoryW(buf);
			PCWSTR newDirectoryPCWSTR = newDirectoryW.c_str();
			WCHAR pathBuffer[MAX_PATH];
			DWORD pathLen = GetEnvironmentVariableW(L"PATH", pathBuffer, MAX_PATH);
			WCHAR newPath[MAX_PATH];
			newPath[0] = L'\0';
			wcscpy_s(newPath, _countof(newPath), (const wchar_t*)pathBuffer);
			wcscat_s(newPath, _countof(newPath), (const wchar_t*)L";");
			wcscat_s(newPath, _countof(newPath), (const wchar_t*)newDirectoryPCWSTR);
			SetEnvironmentVariableW(L"PATH", newPath);
			SetDefaultDllDirectories(LOAD_LIBRARY_SEARCH_DEFAULT_DIRS | LOAD_LIBRARY_SEARCH_USER_DIRS);
			DLL_DIRECTORY_COOKIE ret = AddDllDirectory(newDirectoryPCWSTR);
			delete[] buf;
			if (ret == 0) {
				DWORD error = GetLastError();
				LPTSTR error_text = nullptr;
				FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_IGNORE_INSERTS, NULL, HRESULT_FROM_WIN32(error), MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPTSTR)&error_text, 0, NULL);
				if (error_text != nullptr) {
					ERL_NIF_TERM ret_term = erlang::nif::error(env, error_text);
					LocalFree(error_text);
					return ret_term;
				}
				else {
					ERL_NIF_TERM ret_term = erlang::nif::error(env, "error happened, but cannot get formatted error message");
					return ret_term;
				}
			}
			else {
				return erlang::nif::ok(env);
			}
		}
		else {
			return enif_make_badarg(env);
		}
	}
#ifdef __cplusplus
}
#endif
#else
static ERL_NIF_TERM dll_loader_helper_addDLLDirectory(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
	return erlang::nif::ok(env);
}
#endif

extern "C"
{
	static int on_load(ErlNifEnv* env, void**, ERL_NIF_TERM) {
		return 0;
	}

	static int on_reload(ErlNifEnv* env, void**, ERL_NIF_TERM) {
		return 0;
	}

	static int on_upgrade(ErlNifEnv* env, void**, void**, ERL_NIF_TERM) {
		return 0;
	}


static ErlNifFunc nif_functions[] = {
	{"addDLLDirectory", 1, dll_loader_helper_addDLLDirectory, 0},
};
}

ERL_NIF_INIT(dll_loader_helper_nif, nif_functions, NULL, NULL, NULL, NULL);
