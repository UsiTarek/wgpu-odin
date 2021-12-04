
main:
	odin run examples/example.odin -extra-linker-flags="-Lthirdparty/wgpu-native/target/x86_64-apple-darwin/release/ -L/usr/local/homebrew/opt/sdl2/lib/ " -out="bin/example"
