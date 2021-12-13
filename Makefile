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

ifeq ($(profile),)
Profile := release
else
Profile := $(profile)
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
ifeq ($(Profile),release)
CARGO_PROFILE := release
else
CARGO_PROFILE :=
endif

CARGO_BUILD := cargo build --target=$(CARGO_TARGET) --$(CARGO_PROFILE)

## Rust -- WGPU-Native -- ##

CARGO_WGPU_NATIVE_PATH := thirdparty/wgpu-native

ifeq ($(detected_OS),Windows)
CARGO_BUILD_WGPU_NATIVE_POST := && cp -u 																		  \
								$(CARGO_WGPU_NATIVE_PATH)/target/$(CARGO_TARGET)/$(Profile)/wgpu_native.lib \
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

ODIN_EXTRA_LINKER_FLAGS := -L$(CARGO_WGPU_NATIVE_PATH)/target/$(CARGO_TARGET)/$(Profile)/ \
					  	   -L$(ODIN_HOMEBREW_PATH)/opt/sdl2/lib/
else ifeq ($(detected_OS),Windows)
ODIN_DEFAULT_WIN32_LIBS := Ws2_32.lib AdvAPI32.lib Userenv.lib Bcrypt.lib User32.lib  
ODIN_EXTRA_LINKER_FLAGS := $(ODIN_DEFAULT_WIN32_LIBS) d3dcompiler.lib
endif

ifeq ($(example_name),)
ODIN_EXAMPLE_BIN_NAME :=quad
else
ODIN_EXAMPLE_BIN_NAME :=$(example_name)
endif

ifeq ($(Profile),release)
ODIN_PROFILE := -o:speed
else
ODIN_PROFILE := -debug
endif

ODIN_EXAMPLE_BIN_PATH := bin/examples/$(CARGO_PROFILE)/$(ODIN_EXAMPLE_BIN_NAME)
ODIN_RUN_EXAMPLE_CMD_PRE := mkdir -p $(ODIN_EXAMPLE_BIN_PATH)
ODIN_RUN_EXAMPLE_CMD := $(ODIN_RUN_EXAMPLE_CMD_PRE) &&									\
						odin run 														\
						examples/$(ODIN_EXAMPLE_BIN_NAME)/$(ODIN_EXAMPLE_BIN_NAME).odin \
						$(ODIN_PROFILE)													\
						-target=$(TARGET_OS)_$(ODIN_TARGET_ARCH)  						\
						-extra-linker-flags="$(ODIN_EXTRA_LINKER_FLAGS)" 				\
						-out="$(ODIN_EXAMPLE_BIN_PATH)/$(ODIN_EXAMPLE_BIN_NAME)"
						
ODIN_BUILD_SHARED_LIB_CMD := mkdir -p bin/shared/$(CARGO_PROFILE)/ && \
odin build													   		  \
wgpu/												   		  		  \
-no-entry-point												   		  \
-build-mode=shared											   		  \
$(ODIN_PROFILE)														  \
-target=$(TARGET_OS)_$(ODIN_TARGET_ARCH)  					          \
-extra-linker-flags="$(ODIN_EXTRA_LINKER_FLAGS)" 			   		  \
-out="bin/shared/$(CARGO_PROFILE)/wgpu"

setup:
	git config --global pull.rebase true
	git config --global fetch.prune true
	git config --global diff.colorMoved zebra
	git pull
	git submodule update --init --recursive
	$(CARGO_BUILD_WGPU_NATIVE)

shared: setup
	$(ODIN_BUILD_SHARED_LIB_CMD)

run: setup
	$(ODIN_RUN_EXAMPLE_CMD)
	
clean:
	$(CARGO_CLEAN_WGPU_NATIVE)
	rm -rf bin/*
	
.PHONY: build run clean
