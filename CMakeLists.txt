cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(dll_loader_helper CXX)

if(WIN32)
    if(NOT DEFINED CMAKE_BUILD_TYPE OR "${CMAKE_BUILD_TYPE}" STREQUAL "")
        set(CMAKE_BUILD_TYPE "Release")
    endif()

    if(DEFINED MIX_APP_PATH AND NOT "${MIX_APP_PATH}" STREQUAL "")
        set(PRIV_DIR "${MIX_APP_PATH}/priv")
    else()
        set(PRIV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/priv")
    endif()
    message(STATUS "Using PRIV_DIR: ${PRIV_DIR}")

    if(DEFINED ERTS_INCLUDE_DIR AND NOT "${ERTS_INCLUDE_DIR}" STREQUAL "")
        set(ERTS_INCLUDE_DIR "${ERTS_INCLUDE_DIR}")
    else()
        execute_process(COMMAND powershell -command "erl -noshell -s init stop -eval \"io:format('~ts/erts-~ts/include/', [code:root_dir(), erlang:system_info(version)]).\"" OUTPUT_VARIABLE ERTS_INCLUDE_DIR)
        set(ERTS_INCLUDE_DIR "${ERTS_INCLUDE_DIR}")
    endif()
    message(STATUS "Using ERTS_INCLUDE_DIR: ${ERTS_INCLUDE_DIR}")

    set(C_SRC "${CMAKE_CURRENT_SOURCE_DIR}/c_src")
    set(NIF_SRC "${C_SRC}/dll_loader_helper.cpp")
    include_directories(${ERTS_INCLUDE_DIR})
    include_directories(${C_SRC})

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} $ENV{CFLAGS} /O2 /EHsc /bigobj /wd4996 /wd4267 /wd4068")
    
    add_library(dll_loader_helper SHARED
        ${NIF_SRC}
    )
    set_property(TARGET dll_loader_helper PROPERTY CXX_STANDARD 11)
    set_target_properties(dll_loader_helper PROPERTIES PREFIX "")
    set_target_properties(dll_loader_helper PROPERTIES SUFFIX ".dll")

    if(${CMAKE_VERSION} VERSION_GREATER "3.9")
        cmake_policy(SET CMP0068 NEW)
    endif()
    set_target_properties(dll_loader_helper PROPERTIES
        INSTALL_RPATH_USE_LINK_PATH TRUE
        BUILD_WITH_INSTALL_RPATH TRUE
    )
    install(
        TARGETS dll_loader_helper
        DESTINATION "${PRIV_DIR}")
endif()
