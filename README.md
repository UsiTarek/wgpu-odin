# wgpu-odin
 
 WGPU bindings for Odin.
 
 ## Platforms ( WIP ).
 Windows x86_64 : ⚠ (Makefile is kinda broken, working on it).
 
 MacOS x86_64 : ✅ (For M1, use Rosetta for now)
 
 Linux : ❌ (Coming Soon)
 
 ## Build : 
 
 #### 1 - Building wgpu_native :
 Clone this repository : 
 ```
 git clone https://github.com/UsiTarek/wgpu-odin
 ```
 Run 'make' or 'make setup' :
 ```
 make
 ```
 
  #### 2 - Running examples :
 Test the library with an example : (Requires SDL2)
 ```
 make run
 ```
 You can choose which example to run with the 'example_name' argument :
 ```
 make run example_name=textured_quad
 ```
 
 #### 3 - Enjoy !
 You can include the package using 'import'.
