## https://stackoverflow.com/a/14777895
ifeq ($(OS),Windows_NT) # is Windows_NT on XP, 2000, 7, Vista, 10...
    detected_OS := Windows
else
    detected_OS := $(shell uname)# same as "uname -s"
endif

ifeq ($(detected_OS),Darwin)
else ifeq ($(detected_OS),Windows)
else
$(error [ERROR][OS] Unsupported platform : '$(detected_OS)')
endif

TARGET_ARCH:=x86_64

ifeq ($(detected_OS),Windows)
TARGET_PLATFORM :=pc
TARGET_OS :=windows
else ifeq ($(detected_OS),Darwin)
TARGET_PLATFORM :=apple
TARGET_OS :=darwin
endif

# Rust

CARGO_TARGET_OS :=$(TARGET_OS)
ifeq ($(detected_OS),Windows)
CARGO_TARGET_OS := $(TARGET_OS)-msvc
endif

CARGO_TARGET := $(TARGET_ARCH)-$(TARGET_PLATFORM)-$(CARGO_TARGET_OS)
CARGO_BUILD := cargo build --target=$(CARGO_TARGET)
CARGO_PROFILE := debug

## WGPU-Native
CARGO_WGPU_NATIVE_PATH := thirdparty/wgpu-native

ifeq ($(detected_OS),Windows)
CARGO_BUILD_WGPU_NATIVE_POST := && cp -u 																			 \
								   $(CARGO_WGPU_NATIVE_PATH)/target/$(CARGO_TARGET)/$(CARGO_PROFILE)/wgpu_native.lib \
								   wgpu_native/wgpu_native.lib
endif

CARGO_BUILD_WGPU_NATIVE := pushd $(CARGO_WGPU_NATIVE_PATH) && $(CARGO_BUILD) && popd $(CARGO_BUILD_WGPU_NATIVE_POST)
CARGO_CLEAN_WGPU_NATIVE := pushd $(CARGO_WGPU_NATIVE_PATH)/ && cargo clean && popd && rm -rf wgpu_native/wgpu_native.lib

#Odin

ifeq ($(TARGET_ARCH),x86_64)
ODIN_TARGET_ARCH := amd64
else ifeq ($(TARGET_ARCH),aarch64)
ODIN_TARGET_ARCH := arm64
endif


ifeq ($(detected_OS),Darwin)
ODIN_EXTRA_LINKER_FLAGS := -L$(CARGO_WGPU_NATIVE_PATH)/target/$(CARGO_TARGET)/$(CARGO_PROFILE)/ \
					  -L/usr/local/homebrew/opt/sdl2/lib/
else ifeq ($(detected_OS),Windows)
ODIN_DEFAULT_WINDOWS_LIBS := Ws2_32.lib AdvAPI32.lib Userenv.lib Bcrypt.lib User32.lib  
ODIN_EXTRA_LINKER_FLAGS := $(ODIN_DEFAULT_WINDOWS_LIBS) d3dcompiler.lib
endif

ODIN_RUN_EXAMPLE_CMD := odin run examples/example.odin -debug -target=$(TARGET_OS)_$(ODIN_TARGET_ARCH) -extra-linker-flags="$(ODIN_EXTRA_LINKER_FLAGS)" -out="bin/example"

all:
	$(CARGO_BUILD_WGPU_NATIVE)
	$(ODIN_RUN_EXAMPLE_CMD)

clean:
	$(CARGO_CLEAN_WGPU_NATIVE)
