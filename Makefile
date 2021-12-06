# https://stackoverflow.com/a/14777895
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

ifeq ($(detected_OS),Darwin)
EXTRA_LINKER_FLAGS := -Lthirdparty/wgpu-native/target/x86_64-apple-darwin/release/ \
					  -L/usr/local/homebrew/opt/sdl2/lib/
else ifeq ($(detected_OS),Windows)
DEFAULT_WINDOWS_LIBS := Ws2_32.lib AdvAPI32.lib Userenv.lib Bcrypt.lib User32.lib  
EXTRA_LINKER_FLAGS := $(DEFAULT_WINDOWS_LIBS) d3dcompiler.lib
endif

main:
	odin run examples/example.odin -extra-linker-flags="$(EXTRA_LINKER_FLAGS)" -out="bin/example"

