cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(hello C)

set(CMAKE_BUILD_TYPE "Release")
if(${CMAKE_VERSION} VERSION_GREATER "3.9")
    cmake_policy(SET CMP0068 NEW)
endif()

if(DEFINED MIX_APP_PATH AND NOT "${MIX_APP_PATH}" STREQUAL "")
    set(PRIV_DIR "${MIX_APP_PATH}/priv")
else()
    set(PRIV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/priv")
endif()

# compile a shared library, hello.so/hello.dll
set(HELLO_SRC "${CMAKE_CURRENT_SOURCE_DIR}/hello.c")
add_library(hello SHARED
    ${HELLO_SRC}
)
if(WIN32)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} $ENV{CFLAGS} /O2 /EHsc /bigobj /wd4996 /wd4267 /wd4068")
    set_target_properties(hello PROPERTIES SUFFIX ".dll")
else()
    if(APPLE)
        set(CMAKE_SHARED_LINKER_FLAGS "-flat_namespace -undefined suppress -undefined dynamic_lookup")
    endif()
    set_target_properties(hello PROPERTIES SUFFIX ".so")
endif()

set_property(TARGET hello PROPERTY C_STANDARD 11)

install(
    TARGETS hello
    DESTINATION "${PRIV_DIR}/lib"
)
