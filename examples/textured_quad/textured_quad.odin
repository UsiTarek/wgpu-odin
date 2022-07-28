package examples

import "core:fmt"
import "core:os"
import "core:c"

import sdl "vendor:sdl2"
import stbi "vendor:stb/image"
import wgpu "../../wgpu"

when ODIN_OS == .Windows {
    import win32 "core:sys/windows"
}

Vertex :: struct {
    pos: [2]f32,
    uv: [2]f32,
}

main :: proc () {
    err := sdl.Init({.VIDEO})
    assert(err == 0)
    
    window_flags : sdl.WindowFlags
    when ODIN_OS == .Darwin {
        window_flags = sdl.WindowFlags{.METAL}
    }
    
    window := sdl.CreateWindow(
        "WebGPU Example Quad",
        sdl.WINDOWPOS_CENTERED,
        sdl.WINDOWPOS_CENTERED,
        800,
        600,
        window_flags,
    )
    defer sdl.DestroyWindow(window)
    
    wgpu.SetLogCallback(
        proc(
            level : wgpu.LogLevel,
            msg : cstring,
        ) {
            fmt.println(msg)
        },
    )
    wgpu.SetLogLevel(wgpu.LogLevel.Warn)

    when ODIN_OS == .Darwin {
        metalView := sdl.Metal_CreateView(window)
        defer sdl.Metal_DestroyView(metalView)
        
        surface := wgpu.InstanceCreateSurface(nil, &wgpu.SurfaceDescriptor{
            label = "Metal Surface",
            nextInChain = auto_cast &wgpu.SurfaceDescriptorFromMetalLayer{
                layer = sdl.Metal_GetLayer(metalView),
                chain = {
                    sType = wgpu.SType.SurfaceDescriptorFromMetalLayer,
                },
            },
        })
    }
    when ODIN_OS == .Windows {
        wmInfo: sdl.SysWMinfo = ---
        sdl.GetWindowWMInfo(window, &wmInfo);
        hwnd := wmInfo.info.win.window;
        hinstance := win32.GetModuleHandleA(nil)

        surface := wgpu.InstanceCreateSurface(nil, &(wgpu.SurfaceDescriptor) {
            label = "Windows Surface",
            nextInChain = auto_cast &wgpu.SurfaceDescriptorFromWindowsHWND{
                chain = (wgpu.ChainedStruct) {
                    sType = wgpu.SType.SurfaceDescriptorFromWindowsHWND,
                },
                hinstance = hinstance,
                hwnd = hwnd,
            },
        });
    }

    assert(surface != nil)
    
    adapter : wgpu.Adapter = nil
    wgpu.InstanceRequestAdapter(nil,
                            &(wgpu.RequestAdapterOptions{
                                compatibleSurface = surface,
                                powerPreference = wgpu.PowerPreference.LowPower,
                                forceFallbackAdapter = false,
                            }),
                            proc (
                                status: wgpu.RequestAdapterStatus,
                                adapter: wgpu.Adapter,
                                message: cstring,
                                userdata: rawptr,
                            ) {
                                adapter_props : wgpu.AdapterProperties
                                wgpu.AdapterGetProperties(adapter, &adapter_props)

                                if status == wgpu.RequestAdapterStatus.Success {
                                    user_adapter := cast(^wgpu.Adapter)userdata
                                    user_adapter^ = adapter
                               } 
                            },
                            &adapter)
    assert(adapter != nil)
    
    device : wgpu.Device = nil
    wgpu.AdapterRequestDevice(adapter,
                            &wgpu.DeviceDescriptor {
                                nextInChain = auto_cast &wgpu.DeviceExtras{
                                    chain = wgpu.ChainedStruct{
                                        sType = auto_cast wgpu.NativeSType.DeviceExtras,
                                    },    
                                    label = "Device",
                                },
                                requiredLimits = &wgpu.RequiredLimits{
                                    limits = (wgpu.Limits) {
                                        maxBindGroups = 1,
                                    },
                                },
                            },
                            proc (
                                status: wgpu.RequestDeviceStatus,
                                device : wgpu.Device,
                                message : cstring,
                                userdata : rawptr,
                            ) {
                                if status == wgpu.RequestDeviceStatus.Success {
                                    user_device := cast(^wgpu.Device)userdata
                                    user_device^ = device
                                }
                            },
                            &device)
    assert(device != nil)

    queue := wgpu.DeviceGetQueue(device)
    
    bind_group_layout_0 := wgpu.DeviceCreateBindGroupLayout(
        device,
        &wgpu.BindGroupLayoutDescriptor {
            label = "Texture Bind Group Layout",
            entries = {
                {
                    binding = 0,
                    visibility = wgpu.ShaderStageFlags{ .Fragment },
                    texture = {
                        sampleType = wgpu.TextureSampleType.Float,
                        viewDimension = wgpu.TextureViewDimension.TwoDimensional,
                    },
                },
                {
                    binding = 1,
                    visibility = wgpu.ShaderStageFlags{ .Fragment },
                    sampler = {
                        type = wgpu.SamplerBindingType.Filtering,
                    },
                },
            },
        },
    )
    defer wgpu.BindGroupLayoutDrop(bind_group_layout_0)
   
    pipeline_layout := wgpu.DeviceCreatePipelineLayout(
        device, 
        &wgpu.PipelineLayoutDescriptor{
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
    
    shader_module :=  wgpu.DeviceCreateShaderModule(device, &wgpu.ShaderModuleDescriptor{
        nextInChain = auto_cast &wgpu.ShaderModuleWGSLDescriptor{
            chain = wgpu.ChainedStruct {
                sType = wgpu.SType.ShaderModuleWGSLDescriptor,
            },
            source = cstring(&read_content[0]),
        },
        label = "Quad Shader Module",
    })
    defer wgpu.ShaderModuleDrop(shader_module)

    render_pipeline := wgpu.DeviceCreateRenderPipeline(
        device,
        &wgpu.RenderPipelineDescriptor{
        label = "Quad Render Pipeline",
        layout = pipeline_layout,
        vertex = wgpu.VertexState{
            module = shader_module,
            entryPoint = "vs_main",
            buffers = {
                {
                    arrayStride = size_of(Vertex),
                    stepMode = wgpu.VertexStepMode.Vertex,
                    attributes = {
                        {
                            format = wgpu.VertexFormat.Float32x2,
                            offset = auto_cast offset_of(Vertex, pos),
                            shaderLocation = 0,
                        },
                        {
                            format = wgpu.VertexFormat.Float32x2,
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
                    format = wgpu.TextureFormat.BGRA8UnormSrgb,
                    writeMask = wgpu.ColorWriteMaskFlagsAll,
                },
            },
        },
        primitive = {
            topology = wgpu.PrimitiveTopology.TriangleList,
            cullMode = wgpu.CullMode.None,
        },
        multisample =  {
            count = 1,
            mask = 1,
            alphaToCoverageEnabled = false,
        },
    })
    defer wgpu.RenderPipelineDrop(render_pipeline)
    
    w, h : i32 = 0, 0
    sdl.GetWindowSize(window, &w, &h)
    swapchain := wgpu.DeviceCreateSwapChain(
        device,
        surface,
        &(wgpu.SwapChainDescriptor){
            label = "Swapchain",
            usage = wgpu.TextureUsageFlags{.RenderAttachment},
            format = wgpu.TextureFormat.BGRA8UnormSrgb,
            width = auto_cast w,
            height = auto_cast h,
            presentMode = wgpu.PresentMode.Fifo,
        },
    )
   
    vertices := [6]Vertex {
        { pos = {-1.0, -1.0}, uv = { 0.0, 0.0 } },
        { pos = {-1.0,  1.0}, uv = { 0.0, 1.0 } },
        { pos = { 1.0,  1.0}, uv = { 1.0, 1.0 } },

        { pos = {-1.0, -1.0}, uv = { 0.0, 0.0 } },
        { pos = { 1.0, -1.0}, uv = { 1.0, 0.0 } },
        { pos = { 1.0,  1.0}, uv = { 1.0, 1.0 } },
    }

    vert_buffer := wgpu.DeviceCreateBuffer(
        device, 
        &wgpu.BufferDescriptor{
            label = "",
            usage = wgpu.BufferUsageFlags{ .Vertex, .CopyDst },
            size = size_of(Vertex) * 6, 
        },
    )
    defer wgpu.BufferDrop(vert_buffer)
    
    wgpu.QueueWriteBuffer(queue, vert_buffer, 0, &vertices, size_of(vertices))
    wgpu.QueueSubmit(queue, []wgpu.CommandBuffer{})
    
    texture_width, texture_height, texture_channels_count : i32
    texture_filename : cstring = "examples/textured_quad/textured_quad.png"
	stbi.set_flip_vertically_on_load(1)
    assert(stbi.is_16_bit(texture_filename) == false)
    texture_data := stbi.load(texture_filename, &texture_width, &texture_height, &texture_channels_count, 4)
    
    texture := wgpu.DeviceCreateTexture(
        device, 
        &wgpu.TextureDescriptor{
            label = "Example Texture",
            usage = wgpu.TextureUsageFlags{ .CopyDst, .TextureBinding },
            dimension = wgpu.TextureDimension.TwoDimensional,
            size = wgpu.Extent3D{
                width = auto_cast texture_width,
                height = auto_cast texture_height,
                depthOrArrayLayers = 1,
            },
            format = wgpu.TextureFormat.RGBA8Unorm,
            mipLevelCount = 1,
            sampleCount = 1,
        },
    )
    defer wgpu.TextureDrop(texture)
    
    wgpu.QueueWriteTexture(
        queue = queue,
        destination = &{
            texture = texture,
            mipLevel = 0,
            aspect = wgpu.TextureAspect.All,
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
    wgpu.QueueSubmit(queue, []wgpu.CommandBuffer{})
    
    texture_view := wgpu.TextureCreateView(
        texture,
        &wgpu.TextureViewDescriptor{
            format = wgpu.TextureFormat.RGBA8Unorm,
            dimension = wgpu.TextureViewDimension.TwoDimensional,
            mipLevelCount = 1,
            arrayLayerCount = 1,
            aspect = wgpu.TextureAspect.All,
        },
    )
    defer wgpu.TextureViewDrop(texture_view)
    
    sampler := wgpu.DeviceCreateSampler(
        device,
        &wgpu.SamplerDescriptor{
            magFilter = wgpu.FilterMode.Linear,
            minFilter = wgpu.FilterMode.Linear,
        },
    )
    defer wgpu.SamplerDrop(sampler)
    
    texture_bind_group := wgpu.DeviceCreateBindGroup(
        device,
        &wgpu.BindGroupDescriptor{
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
    defer wgpu.BindGroupDrop(texture_bind_group)
    
    main_loop: for {
        for e: sdl.Event; sdl.PollEvent(&e); {
            #partial switch(e.type) {
                case .QUIT:
                    break main_loop;
            }
        }
        
        current_view := wgpu.SwapChainGetCurrentTextureView(swapchain)
        
        cmd_encoder := wgpu.DeviceCreateCommandEncoder(
            device, 
            &wgpu.CommandEncoderDescriptor{
                label = "Main Command Encoder",
            },
        )

        render_pass := wgpu.CommandEncoderBeginRenderPass(
            cmd_encoder, 
            &wgpu.RenderPassDescriptor{
                label = "Main Render Pass",
                colorAttachments = {
                    {
                        view = current_view,
                        loadOp = wgpu.LoadOp.Clear,
                        storeOp = wgpu.StoreOp.Store,
                        clearColor = wgpu.Color{ 0.1, 0.1, 0.25, 1.0 },
                    },
                },
            },
        )
        wgpu.RenderPassEncoderSetPipeline(render_pass, render_pipeline)
        wgpu.RenderPassEncoderSetBindGroup(render_pass, 0, texture_bind_group, 0, nil)
        wgpu.RenderPassEncoderSetVertexBuffer(render_pass, 0, vert_buffer, 0, 0)
        wgpu.RenderPassEncoderDraw(render_pass, len(vertices), 1, 0, 0)
        wgpu.RenderPassEncoderEndPass(render_pass)

        cmd_buffer := wgpu.CommandEncoderFinish(cmd_encoder, &wgpu.CommandBufferDescriptor{
            label = "Main Command Buffer",
        })
        wgpu.QueueSubmit(queue, []wgpu.CommandBuffer{cmd_buffer});

        wgpu.SwapChainPresent(swapchain)
    }
}