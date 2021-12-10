package examples

import stbi "vendor:stb/image"
import "core:fmt"
import "core:os"
import "core:c"
import SDL "vendor:sdl2"
import WGPU "../../wgpu_native"

when ODIN_OS == "windows" {
    import "core:sys/win32"
}

Vertex :: struct {
    pos: [2]f32,
    uv: [2]f32,
}

VERTICES :: [6]Vertex {
    { pos = {-1.0, -1.0}, uv = { 0.0, 0.0 } },
    { pos = {-1.0,  1.0}, uv = { 0.0, 1.0 } },
    { pos = { 1.0,  1.0}, uv = { 1.0, 1.0 } },

    { pos = {-1.0, -1.0}, uv = { 0.0, 0.0 } },
    { pos = { 1.0, -1.0}, uv = { 1.0, 0.0 } },
    { pos = { 1.0,  1.0}, uv = { 1.0, 1.0 } },
}

request_adapter_callback :: proc (
    status: WGPU.RequestAdapterStatus,
    adapter: WGPU.Adapter,
    message: cstring,
    userdata: rawptr,
) {
    adapter_props : WGPU.AdapterProperties
    WGPU.AdapterGetProperties(adapter, &adapter_props)

    if status == WGPU.RequestAdapterStatus.Success {
        user_adapter := cast(^WGPU.Adapter)userdata
        user_adapter^ = adapter
   } 
}

request_device_callback :: proc (
    status: WGPU.RequestDeviceStatus,
    device : WGPU.Device,
    message : cstring,
    userdata : rawptr,
) {
    if status == WGPU.RequestDeviceStatus.Success {
        user_device := cast(^WGPU.Device)userdata
        user_device^ = device
    }
}

error_callback :: proc(
    level : WGPU.LogLevel,
    msg : cstring,
) {
    fmt.println(msg)
}

main :: proc () {
    err := SDL.Init({.VIDEO})
    assert(err == 0)
    
    window_flags : SDL.WindowFlags
    when ODIN_OS == "darwin" {
        window_flags = SDL.WindowFlags{.METAL}
    }
    
    window := SDL.CreateWindow(
        "WebGPU Example Quad",
        SDL.WINDOWPOS_CENTERED,
        SDL.WINDOWPOS_CENTERED,
        800,
        600,
        window_flags,
    )
    defer SDL.DestroyWindow(window)
    
    WGPU.SetLogCallback(error_callback)
    WGPU.SetLogLevel(WGPU.LogLevel.Warn)

    when ODIN_OS == "darwin" {
        metalView := SDL.Metal_CreateView(window)
        defer SDL.Metal_DestroyView(metalView)
        
        surface := WGPU.InstanceCreateSurface(nil, &WGPU.SurfaceDescriptor{
            label = "Metal Surface",
            nextInChain = auto_cast &WGPU.SurfaceDescriptorFromMetalLayer{
                layer = SDL.Metal_GetLayer(metalView),
                chain = {
                    sType = WGPU.SType.SurfaceDescriptorFromMetalLayer,
                },
            },
        })
    }
    when ODIN_OS == "windows" {
        wmInfo: SDL.SysWMinfo = ---
        SDL.GetWindowWMInfo(window, &wmInfo);
        hwnd := wmInfo.info.win.window;
        hinstance := win32.get_module_handle_a(nil)

        surface := WGPU.InstanceCreateSurface(nil, &(WGPU.SurfaceDescriptor) {
            label = "Windows Surface",
            nextInChain = auto_cast &WGPU.SurfaceDescriptorFromWindowsHWND{
                chain = (WGPU.ChainedStruct) {
                    sType = WGPU.SType.SurfaceDescriptorFromWindowsHWND,
                },
                hinstance = hinstance,
                hwnd = hwnd,
            },
        });
    }

    assert(surface != nil)
    
    adapter : WGPU.Adapter = nil
    WGPU.InstanceRequestAdapter(nil,
                            &(WGPU.RequestAdapterOptions{
                                compatibleSurface = surface,
                                powerPreference = WGPU.PowerPreference.LowPower,
                                forceFallbackAdapter = false,
                            }),
                            request_adapter_callback,
                            &adapter)
    assert(adapter != nil)
    
    device : WGPU.Device = nil
    WGPU.AdapterRequestDevice(adapter,
                            &WGPU.DeviceDescriptor {
                                nextInChain = auto_cast &WGPU.DeviceExtras{
                                    chain = WGPU.ChainedStruct{
                                        sType = auto_cast WGPU.NativeSType.DeviceExtras,
                                    },    
                                    label = "Device",
                                },
                                requiredLimits = &WGPU.RequiredLimits{
                                    limits = (WGPU.Limits) {
                                        maxBindGroups = 1,
                                    },
                                },
                            },
                            request_device_callback,
                            &device)
    assert(device != nil)

    queue := WGPU.DeviceGetQueue(device)
    
    bind_group_layout_0 := WGPU.DeviceCreateBindGroupLayout(
        device,
        &WGPU.BindGroupLayoutDescriptor {
            label = "Texture Bind Group Layout",
            entries = {
                {
                    binding = 0,
                    visibility = WGPU.ShaderStageFlags{ .Fragment },
                    texture = {
                        sampleType = WGPU.TextureSampleType.Float,
                        viewDimension = WGPU.TextureViewDimension.TwoDimensional,
                    },
                },
                {
                    binding = 1,
                    visibility = WGPU.ShaderStageFlags{ .Fragment },
                    sampler = {
                        type = WGPU.SamplerBindingType.Filtering,
                    },
                },
            },
        },
    )
    defer WGPU.BindGroupLayoutDrop(bind_group_layout_0)
   
    pipeline_layout := WGPU.DeviceCreatePipelineLayout(
        device, 
        &WGPU.PipelineLayoutDescriptor{
            label = "Empty Pipeline Layout",
            bindGroupLayouts = {
                bind_group_layout_0,
            },
        },
    )
    
    read_content, read_ok := os.read_entire_file_from_filename("examples/textured_quad/textured_quad.wgsl"); 
    if !read_ok {
        panic("Could not open or read file.")
    }
    defer delete(read_content)
    
    shader_module :=  WGPU.DeviceCreateShaderModule(device, &WGPU.ShaderModuleDescriptor{
        nextInChain = auto_cast &WGPU.ShaderModuleWGSLDescriptor{
            chain = WGPU.ChainedStruct {
                sType = WGPU.SType.ShaderModuleWGSLDescriptor,
            },
            source = cstring(&read_content[0]),
        },
        label = "Quad Shader Module",
    })
    defer WGPU.ShaderModuleDrop(shader_module)

    render_pipeline := WGPU.DeviceCreateRenderPipeline(
        device,
        &WGPU.RenderPipelineDescriptor{
        label = "Quad Render Pipeline",
        layout = pipeline_layout,
        vertex = WGPU.VertexState{
            module = shader_module,
            entryPoint = "vs_main",
            buffers = {
                {
                    arrayStride = size_of(Vertex),
                    stepMode = WGPU.VertexStepMode.Vertex,
                    attributes = {
                        {
                            format = WGPU.VertexFormat.Float32x2,
                            offset = auto_cast offset_of(Vertex, pos),
                            shaderLocation = 0,
                        },
                        {
                            format = WGPU.VertexFormat.Float32x2,
                            offset = auto_cast offset_of(Vertex, uv),
                            shaderLocation = 1,
                        },
                    },
                },
            },
        },
        fragment = &{
            module = shader_module,
            entryPoint = "fs_main",
            targets = {
                {
                    format = WGPU.TextureFormat.BGRA8UnormSrgb,
                    writeMask = WGPU.ColorWriteMaskFlagsAll,
                },
            },
        },
        primitive = {
            topology = WGPU.PrimitiveTopology.TriangleList,
            cullMode = WGPU.CullMode.None,
        },
        multisample =  {
            count = 1,
            mask = 1,
            alphaToCoverageEnabled = false,
        },
    })
    defer WGPU.RenderPipelineDrop(render_pipeline)
    
    w, h : i32 = 0, 0
    SDL.GetWindowSize(window, &w, &h)
    swapchain := WGPU.DeviceCreateSwapChain(
        device,
        surface,
        &(WGPU.SwapChainDescriptor){
            label = "Swapchain",
            usage = WGPU.TextureUsageFlags{.RenderAttachment},
            format = WGPU.TextureFormat.BGRA8UnormSrgb,
            width = auto_cast w,
            height = auto_cast h,
            presentMode = WGPU.PresentMode.Fifo,
        },
    )
    
    vert_buffer := WGPU.DeviceCreateBuffer(
        device, 
        &WGPU.BufferDescriptor{
            label = "",
            usage = WGPU.BufferUsageFlags{ .Vertex, .CopyDst },
            size = size_of(Vertex) * 6, 
        },
    )
    defer WGPU.BufferDrop(vert_buffer)
    
    vertices := VERTICES
    WGPU.QueueWriteBuffer(queue, vert_buffer, 0, &vertices, size_of(vertices))
    WGPU.QueueSubmit(queue, []WGPU.CommandBuffer{})
    
    texture_width, texture_height, texture_channels_count : i32
    texture_filename : cstring = "examples/textured_quad/textured_quad.png"
    assert(stbi.is_16_bit(texture_filename) == false)
	stbi.set_flip_vertically_on_load(1)
    texture_data := stbi.load(texture_filename, &texture_width, &texture_height, &texture_channels_count, 4)
    
    texture := WGPU.DeviceCreateTexture(
        device, 
        &WGPU.TextureDescriptor{
            label = "Example Texture",
            usage = WGPU.TextureUsageFlags{ .CopyDst, .TextureBinding },
            dimension = WGPU.TextureDimension.TwoDimensional,
            size = WGPU.Extent3D{
                width = auto_cast texture_width,
                height = auto_cast texture_height,
                depthOrArrayLayers = 1,
            },
            format = WGPU.TextureFormat.RGBA8Unorm,
            mipLevelCount = 1,
            sampleCount = 1,
        },
    )
    defer WGPU.TextureDrop(texture)
    
    WGPU.QueueWriteTexture(
        queue = queue,
        destination = &{
            texture = texture,
            mipLevel = 0,
            aspect = WGPU.TextureAspect.All,
        },
        data = auto_cast &texture_data[0],
        dataSize = auto_cast (texture_width * texture_height * texture_channels_count),
        dataLayout = &{
            offset = 0,
            bytesPerRow = auto_cast ( texture_channels_count * texture_width ),
            rowsPerImage = auto_cast texture_height,
        },
        writeSize = &{
                width = auto_cast texture_width,
                height = auto_cast texture_height,
                depthOrArrayLayers = 1,
            },
    )
    WGPU.QueueSubmit(queue, []WGPU.CommandBuffer{})
    
    texture_view := WGPU.TextureCreateView(
        texture,
        &WGPU.TextureViewDescriptor{
            format = WGPU.TextureFormat.RGBA8Unorm,
            dimension = WGPU.TextureViewDimension.TwoDimensional,
            mipLevelCount = 1,
            arrayLayerCount = 1,
            aspect = WGPU.TextureAspect.All,
        },
    )
    
    sampler := WGPU.DeviceCreateSampler(
        device,
        &WGPU.SamplerDescriptor{
            magFilter = WGPU.FilterMode.Linear,
            minFilter = WGPU.FilterMode.Linear,
        },
    )
    
    texture_bind_group := WGPU.DeviceCreateBindGroup(
        device,
        &WGPU.BindGroupDescriptor{
            layout = bind_group_layout_0,
            entries = {
                {
                    binding = 0,
                    textureView = texture_view,
                },
                {
                    binding = 1,
                    sampler = sampler,
                },
            },
        },
    )
    
    main_loop: for {
        for e: SDL.Event; SDL.PollEvent(&e) != 0; {
            #partial switch(e.type) {
                case .QUIT:
                    break main_loop;
            }
        }
        
        current_view := WGPU.SwapChainGetCurrentTextureView(swapchain)
        
        cmd_encoder := WGPU.DeviceCreateCommandEncoder(
            device, 
            &WGPU.CommandEncoderDescriptor{
                label = "Main Command Encoder",
            },
        )

        render_pass := WGPU.CommandEncoderBeginRenderPass(
            cmd_encoder, 
            &WGPU.RenderPassDescriptor{
                label = "Main Render Pass",
                colorAttachments = {
                    {
                        view = current_view,
                        loadOp = WGPU.LoadOp.Clear,
                        storeOp = WGPU.StoreOp.Store,
                        clearColor = WGPU.Color{ 0.1, 0.1, 0.25, 1.0 },
                    },
                },
            },
        )
        WGPU.RenderPassEncoderSetPipeline(render_pass, render_pipeline)
        WGPU.RenderPassEncoderSetBindGroup(render_pass, 0, texture_bind_group, 0, nil)
        WGPU.RenderPassEncoderSetVertexBuffer(render_pass, 0, vert_buffer, 0, 0)
        WGPU.RenderPassEncoderDraw(render_pass, len(VERTICES), 1, 0, 0)
        WGPU.RenderPassEncoderEndPass(render_pass)

        cmd_buffer := WGPU.CommandEncoderFinish(cmd_encoder, &WGPU.CommandBufferDescriptor{
            label = "Main Command Buffer",
        })
        WGPU.QueueSubmit(queue, []WGPU.CommandBuffer{cmd_buffer});

        WGPU.SwapChainPresent(swapchain)
    }
}