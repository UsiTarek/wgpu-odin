# --- General --- #

## https://stackoverflow.com/a/14777895
ifeq ($(OS),Windows_NT) # is Windows_NT on XP, 2000, 7, Vista, 10...
    detected_OS := Windows
else
    detected_OS := $(shell uname)
endif

ifeq ($(detected_OS),Darwin)
else ifeq ($(detected_OS),Windows)
else
$(error [ERROR][OS] Unsupported platform : '$(detected_OS)')
endif

## -- Target Triple -- ##
TARGET_ARCH:=x86_64
ifeq ($(detected_OS),Windows)
TARGET_PLATFORM :=pc
TARGET_OS :=windows
else ifeq ($(detected_OS),Darwin)
TARGET_PLATFORM :=apple
TARGET_OS :=darwin
endif

# --- Rust --- #

CARGO_TARGET_OS :=$(TARGET_OS)
ifeq ($(detected_OS),Windows)
CARGO_TARGET_OS := $(TARGET_OS)-msvc
endif

CARGO_TARGET := $(TARGET_ARCH)-$(TARGET_PLATFORM)-$(CARGO_TARGET_OS)
CARGO_BUILD := cargo build --target=$(CARGO_TARGET)
CARGO_PROFILE := debug

## -- WGPU-Native -- ##
CARGO_WGPU_NATIVE_PATH := thirdparty/wgpu-native

ifeq ($(detected_OS),Windows)
CARGO_BUILD_WGPU_NATIVE_POST := && cp -u 																			 \
								   $(CARGO_WGPU_NATIVE_PATH)/target/$(CARGO_TARGET)/$(CARGO_PROFILE)/wgpu_native.lib \
								   wgpu_native/wgpu_native.lib
endif

CARGO_BUILD_WGPU_NATIVE := pushd $(CARGO_WGPU_NATIVE_PATH) && $(CARGO_BUILD) && popd $(CARGO_BUILD_WGPU_NATIVE_POST)
CARGO_CLEAN_WGPU_NATIVE := pushd $(CARGO_WGPU_NATIVE_PATH)/ && cargo clean && popd && rm -rf wgpu_native/wgpu_native.lib

# --- Odin --- #

ifeq ($(TARGET_ARCH),x86_64)
ODIN_TARGET_ARCH := amd64
else ifeq ($(TARGET_ARCH),aarch64)
ODIN_TARGET_ARCH := arm64
endif

ifeq ($(detected_OS),Darwin)

ifeq ($(TARGET_ARCH),x86_64)
ODIN_HOMEBREW_PATH := /usr/local/homebrew
else ifeq ($(TARGET_ARCH),aarch64)
ODIN_HOMEBREW_PATH := /opt/homebrew
endif

ODIN_EXTRA_LINKER_FLAGS := -L$(CARGO_WGPU_NATIVE_PATH)/target/$(CARGO_TARGET)/$(CARGO_PROFILE)/ \
					  	   -L$(ODIN_HOMEBREW_PATH)/opt/sdl2/lib/
else ifeq ($(detected_OS),Windows)
ODIN_DEFAULT_WIN32_LIBS := Ws2_32.lib AdvAPI32.lib Userenv.lib Bcrypt.lib User32.lib  
ODIN_EXTRA_LINKER_FLAGS := $(ODIN_DEFAULT_WIN32_LIBS) d3dcompiler.lib
endif

ODIN_EXAMPLE_BIN_NAME :=quad
ODIN_EXAMPLE_BIN_PATH := bin/example
ODIN_RUN_EXAMPLE_CMD_PRE := mkdir -p $(ODIN_EXAMPLE_BIN_PATH)
ODIN_RUN_EXAMPLE_CMD := $(ODIN_RUN_EXAMPLE_CMD_PRE) &&								\
						odin run 													\
						examples/$(ODIN_EXAMPLE_BIN_NAME).odin 						\
						-debug 														\
						-target=$(TARGET_OS)_$(ODIN_TARGET_ARCH)  					\
						-extra-linker-flags="$(ODIN_EXTRA_LINKER_FLAGS)" 			\
						-out="$(ODIN_EXAMPLE_BIN_PATH)/$(ODIN_EXAMPLE_BIN_NAME)"
						
ODIN_BUILD_EXAMPLE_CMD := mkdir -p bin/$(CARGO_PROFILE)/ && \
odin build													\
wgpu_native/												\
-no-entry-point												\
-build-mode=shared											\
-debug 														\
-target=$(TARGET_OS)_$(ODIN_TARGET_ARCH)  					\
-extra-linker-flags="$(ODIN_EXTRA_LINKER_FLAGS)" 			\
-out="bin/$(CARGO_PROFILE)/wgpu"


all:
	$(CARGO_BUILD_WGPU_NATIVE)
	$(ODIN_RUN_EXAMPLE_CMD)
	
build:
	$(CARGO_BUILD_WGPU_NATIVE)
	$(ODIN_BUILD_EXAMPLE_CMD)

clean:
	$(CARGO_CLEAN_WGPU_NATIVE)
