cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(hello C)

# common settings
set(CMAKE_BUILD_TYPE "Release")
if(${CMAKE_VERSION} VERSION_GREATER "3.9")
    cmake_policy(SET CMP0068 NEW)
endif()

# compile the NIF library, hello_nif
if(DEFINED MIX_APP_PATH AND NOT "${MIX_APP_PATH}" STREQUAL "")
    set(PRIV_DIR "${MIX_APP_PATH}/priv")
else()
    set(PRIV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/priv")
endif()
message(STATUS "Using PRIV_DIR: ${PRIV_DIR}")

if(DEFINED ERTS_INCLUDE_DIR AND NOT "${ERTS_INCLUDE_DIR}" STREQUAL "")
    set(ERTS_INCLUDE_DIR "${ERTS_INCLUDE_DIR}")
else()
    if(WIN32)
        execute_process(COMMAND powershell -command "erl -noshell -s init stop -eval \"io:format('~ts/erts-~ts/include/', [code:root_dir(), erlang:system_info(version)]).\"" OUTPUT_VARIABLE ERTS_INCLUDE_DIR)
        set(ERTS_INCLUDE_DIR "${ERTS_INCLUDE_DIR}")
    else()
        execute_process(COMMAND bash -c "erl -noshell -s init stop -eval \"io:format('~ts/erts-~ts/include/', [code:root_dir(), erlang:system_info(version)]).\"" OUTPUT_VARIABLE ERTS_INCLUDE_DIR)
        set(ERTS_INCLUDE_DIR "${ERTS_INCLUDE_DIR}")
    endif()
endif()
message(STATUS "Using ERTS_INCLUDE_DIR: ${ERTS_INCLUDE_DIR}")

set(C_SRC "${CMAKE_CURRENT_SOURCE_DIR}/c_src")
set(NIF_SRC "${C_SRC}/hello_nif.c")
include_directories(${ERTS_INCLUDE_DIR})
link_directories(${PRIV_DIR}/lib)

add_library(hello_nif SHARED
    ${NIF_SRC}
)
target_link_libraries(hello_nif
    hello
)
set_target_properties(hello_nif PROPERTIES PREFIX "")
if(WIN32)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} $ENV{CFLAGS} /O2 /EHsc /bigobj /wd4996 /wd4267 /wd4068")
    set_target_properties(hello_nif PROPERTIES SUFFIX ".dll")
else()
    if(UNIX AND NOT APPLE)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -shared")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-unused-but-set-variable")
        set_target_properties(hello_nif PROPERTIES INSTALL_RPATH "\$ORIGIN/lib")
    elseif(APPLE)
        set(CMAKE_SHARED_LINKER_FLAGS "-flat_namespace -undefined suppress -undefined dynamic_lookup")
        set_target_properties(hello_nif PROPERTIES INSTALL_RPATH "@loader_path/./lib")
    endif()
    set_target_properties(hello_nif PROPERTIES SUFFIX ".so")
endif()
set_target_properties(hello_nif PROPERTIES
    INSTALL_RPATH_USE_LINK_PATH TRUE
    BUILD_WITH_INSTALL_RPATH TRUE
)

install(
    TARGETS hello_nif
    DESTINATION "${PRIV_DIR}"
)
