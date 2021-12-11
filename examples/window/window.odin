package examples

import "core:fmt"
import SDL "vendor:sdl2"
import WGPU "../../wgpu"

when ODIN_OS == "windows" {
    import "core:sys/win32"
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
    } else when ODIN_OS == "windows" {
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
    
    w, h : i32 = 0, 0
    SDL.GetWindowSize(window, &w, &h)
    swapchain := WGPU.DeviceCreateSwapChain(device, surface, &(WGPU.SwapChainDescriptor){
        label = "Swapchain",
        usage = WGPU.TextureUsageFlags{.RenderAttachment},
        format = WGPU.TextureFormat.BGRA8UnormSrgb,
        width = auto_cast w,
        height = auto_cast h,
        presentMode = WGPU.PresentMode.Fifo,
    })

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
        WGPU.RenderPassEncoderEndPass(render_pass)

        cmd_buffer := WGPU.CommandEncoderFinish(cmd_encoder, &WGPU.CommandBufferDescriptor{
            label = "Main Command Buffer",
        })
        WGPU.QueueSubmit(queue, []WGPU.CommandBuffer{cmd_buffer});

        WGPU.SwapChainPresent(swapchain)
    }
}