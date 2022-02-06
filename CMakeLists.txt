cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(dll_loader_helper CXX)

include_directories("${ERTS_INCLUDE_DIR}")

string(REPLACE "\\" "/" C_SRC "${C_SRC}")
file(GLOB dll_loader_helper_sources "${C_SRC}/*.hpp" "${C_SRC}/*.cpp")

add_library(dll_loader_helper SHARED ${dll_loader_helper_sources})
set_target_properties(dll_loader_helper PROPERTIES PREFIX "")

if(WIN32)
	set_target_properties(dll_loader_helper PROPERTIES SUFFIX ".dll")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Ob2 /wd4996 /wd4267 /wd4068")
else()
	message(WARNING "This library (:dll_loader_helper) is intended to be used on Windows only.")
	set_target_properties(dll_loader_helper PROPERTIES SUFFIX ".so")
	if(UNIX AND NOT APPLE)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-but-set-variable")
	elseif(UNIX AND APPLE)
		# Although the compiler complains about not using these,
		# things only work with them set
		set(CMAKE_SHARED_LINKER_FLAGS "-flat_namespace -undefined suppress -undefined dynamic_lookup")
	endif()
endif()
