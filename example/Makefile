all: hello_nif_dll

.DEFAULT_GLOBAL := build
build: hello_nif_dll

hello_dll:
	mkdir -p build_so && cd build_so && \
  	cmake -DCMAKE_BUILD_TYPE="Release" \
      -DMIX_APP_PATH="$(MIX_APP_PATH)" ../shared_lib_src && \
    cmake --build . --config Release && \
    cmake --install . --config Release && cd ..

hello_nif_dll: hello_dll
	mkdir -p build && cd build && \
  	cmake -DCMAKE_BUILD_TYPE="Release" \
      -DMIX_APP_PATH="$(MIX_APP_PATH)" \
      -DERTS_INCLUDE_DIR="$(ERTS_INCLUDE_DIR)" .. && \
    cmake --build . --config Release && \
    cmake --install . --config Release && cd ..

.PHONY: all
