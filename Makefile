ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
    detected_OS := Windows
else
    detected_OS := $(shell uname)# same as "uname -s"
endif


ifeq ($(detected_OS),Darwin)
main:
		odin run examples/example.odin -extra-linker-flags="-Lthirdparty/wgpu-native/target/x86_64-apple-darwin/release/ -L/usr/local/homebrew/opt/sdl2/lib/ " -out="bin/example"
else
main:
	echo $(detected_OS) Not supported yet.
endif