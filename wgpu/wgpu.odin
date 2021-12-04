package wgpu

import n "../wgpu_native"
import "core:strings"

Adapter :: n.Adapter
Bind_Group :: n.BindGroup
Bind_Group_Layout :: n.BindGroupLayout
Buffer :: n.Buffer
Command_Buffer :: n.CommandBuffer
Command_Encoder :: n.CommandEncoder
Compute_Pass_Encoder :: n.ComputePassEncoder
Compute_Pipeline :: n.ComputePipeline
Device :: n.Device
Instance :: n.Instance
Pipeline_Layout :: n.PipelineLayout
Query_Set :: n.QuerySet
Queue :: n.Queue
Render_Bundle :: n.RenderBundle
RenderBundle_Encoder :: n.RenderBundleEncoder
RenderPass_Encoder :: n.RenderPassEncoder
Render_Pipeline :: n.RenderPipeline
Sampler :: n.Sampler
Shader_Module :: n.ShaderModule
Surface :: n.Surface
SwapChain :: n.SwapChain
Texture :: n.Texture
Texture_View :: n.TextureView

Buffer_Map_Callback :: n.BufferMapCallback

Create_Compute_Pipeline_Async_Callback :: #type proc(
    status: Create_Pipeline_Async_Status,
    pipeline: Compute_Pipeline,
    message: string,
    out_pipeline: ^Compute_Pipeline,
)
Create_Render_Pipeline_Async_Callback :: #type proc(
    status: Create_Pipeline_Async_Status,
    pipeline: Render_Pipeline,
    messsage: string,
    out_pipeline: ^Render_Pipeline,
)

Device_Lost_Callback :: #type proc(
    reason : Device_Lost_Reason,
    message : string,
    userdata : rawptr,
)

Error_Callback :: #type proc(
    type : Error_Type,
    message : string,
    userdata : rawptr,
)

Queue_Work_Done_Callback :: #type proc(
    status : Queue_Work_Done_Status,
    userdata : rawptr,
)

RequestAdapterCallback :: #type proc(
    status : Request_Adapter_Status,
    adapter : Adapter,
    message : cstring,
    userdata : rawptr,
)

Request_Device_Callback :: #type proc(
    status : Request_Device_Status,
    device : Device,
    message : string,
    userdata : rawptr,
)

Adapter_Type :: n.AdapterType
Address_Mode :: n.AddressMode
Backend_Type :: n.BackendType
Blend_Factor :: n.BlendFactor
Blend_Operation :: n.BlendOperation
Buffer_Binding_Type :: n.BufferBindingType
Buffer_Map_Async_Status :: n.BufferMapAsyncStatus
Compare_Function :: n.CompareFunction
Compilation_Message_Type :: n.CompilationMessageType
Create_Pipeline_Async_Status :: n.CreatePipelineAsyncStatus
Cull_Mode :: n.CullMode
Device_Lost_Reason :: n.DeviceLostReason
Error_Filter :: n.ErrorFilter
Error_Type :: n.ErrorType
Feature_Name :: n.FeatureName
Filter_Mode :: n.FilterMode
Front_Face :: n.FrontFace
Index_Format :: n.IndexFormat
Load_Op :: n.LoadOp
Pipeline_Statistic_Name :: n.PipelineStatisticName
Power_Preference :: n.PowerPreference
Present_Mode :: n.PresentMode
Primitive_Topology :: n.PrimitiveTopology
Query_Type :: n.QueryType
Queue_Work_Done_Status :: n.QueueWorkDoneStatus
Request_Adapter_Status :: n.RequestAdapterStatus
Request_Device_Status :: n.RequestDeviceStatus
S_Type :: n.SType
Sampler_Binding_Type :: n.SamplerBindingType
Stencil_Operation :: n.StencilOperation
Storage_Texture_Access :: n.StorageTextureAccess
Store_Op :: n.StoreOp
Texture_Aspect :: n.TextureAspect
Texture_Component_Type :: n.TextureComponentType
Texture_Dimension :: n.TextureDimension
Texture_Format :: n.TextureFormat
Texture_Sample_Type :: n.TextureSampleType
Texture_View_Dimension :: n.TextureViewDimension
Vertex_Format :: n.VertexFormat
Vertex_Step_Mode :: n.VertexStepMode
Buffer_Usage :: n.BufferUsage
Color_Write_Mask :: n.ColorWriteMask
Map_Mode :: n.MapMode
Shader_Stage :: n.ShaderStage
Texture_Usage :: n.TextureUsage

Adapter_Properties :: struct {
    vendorID : u32,
    deviceID : u32,
    name : string,
    driverDescription : string,
    adapterType : Adapter_Type,
    backendType : Backend_Type,
}

Bind_Group_Entry :: struct {
    binding : u32,
    buffer : Buffer,
    offset : uint,
    size : uint,
    sampler : Sampler,
    textureView : Texture_View,
}

Blend_Component :: struct {
    operation : Blend_Operation,
    srcFactor : Blend_Factor,
    dstFactor : Blend_Factor,
}

Buffer_Binding_Layout :: struct {
    type : Buffer_Binding_Type,
    hasDynamicOffset : bool,
    minBindingSize : uint,
}

Buffer_Descriptor :: struct {
    label : cstring,
    usage : []Buffer_Usage,
    size : uint,
    mappedAtCreation : bool,
}

Color :: struct {
    r : f64,
    g : f64,
    b : f64,
    a : f64,
}

Command_Buffer_Descriptor :: struct {
    label : string,
}

Compilation_Message :: struct {
    message : string,
    type : Compilation_Message_Type,
    lineNum : uint,
    linePos : uint,
    offset : uint,
    length : uint,
}

Compute_Pass_Descriptor :: struct {
    label : string,
}

Constant_Entry :: struct {
    key : string,
    value : f64,
}

Extent_3D :: n.Extent3D
InstanceDescriptor :: struct {} //TODO Choose runtime backend here

Limits :: n.Limits
Multisample_State :: n.MultisampleState
Origin_3D :: n.Origin3D

Pipeline_Layout_Descriptor :: struct {
    label : string,
    bindGroupLayouts: []Bind_Group_Layout,
}

Primitive_Depth_Clamping_State :: struct {
    clampDepth : bool,
}

Primitive_State :: struct {
    topology : Primitive_Topology,
    stripIndexFormat : Index_Format,
    frontFace : Front_Face,
    cullMode : Cull_Mode,
}

Query_Set_Descriptor :: struct {
    label : string,
    type : Query_Type,
    count : u32,
    pipelineStatistics : []Pipeline_Statistic_Name,
}

Render_Bundle_Descriptor :: struct {
    label : string,
}

Render_Bundle_Encoder_Descriptor :: struct {
    label : string,
    colorFormats : []Texture_Format,
    depthStencilFormat : Texture_Format,
    sampleCount : u32,
}

Render_Pass_Depth_Stencil_Attachment :: struct {
    view : Texture_View,
    depthLoadOp : Load_Op,
    depthStoreOp : Store_Op,
    clearDepth : f32,
    depthReadOnly : bool,
    stencilLoadOp : Load_Op,
    stencilStoreOp : Store_Op,
    clearStencil : u32,
    stencilReadOnly : bool,
}

Request_Adapter_Options :: struct {
    compatibleSurface : Surface,
    powerPreference : Power_Preference,
    forceFallbackAdapter : bool,
}

Sampler_Binding_Layout :: struct {
    type : Sampler_Binding_Type,
}

Sampler_Descriptor :: struct {
    label : string,
    addressModeU : Address_Mode,
    addressModeV : Address_Mode,
    addressModeW : Address_Mode,
    magFilter : Filter_Mode,
    minFilter : Filter_Mode,
    mipmapFilter : Filter_Mode,
    lodMinClamp : f32,
    lodMaxClamp : f32,
    compare : Compare_Function,
    maxAnisotropy : u16,
}

Shader_Module_SPIRV_Descriptor :: struct {
    code : []u32,
}

Shader_Module_WGSL_Descriptor :: struct {
    source : string,
}

Stencil_Face_State :: struct {
    compare : Compare_Function,
    failOp : Stencil_Operation,
    depthFailOp : Stencil_Operation,
    passOp : Stencil_Operation,
}

Storage_Texture_Binding_Layout :: struct {
    access : Storage_Texture_Access,
    format : Texture_Format,
    viewDimension : Texture_View_Dimension,
}

Surface_Descriptor_From_Canvas_HTML_Selector :: struct {
    selector : string,
}

Surface_Descriptor_From_Metal_Layer :: struct {
    layer : rawptr,
}

Surface_Descriptor_From_Windows_HWND :: struct {
    hinstance : rawptr,
    hwnd : rawptr,
}

Surface_Descriptor_From_Xlib :: struct {
    display : rawptr,
    window : u32,
}

SwapChain_Descriptor :: struct {
    label : string,
    usage : []Texture_Usage,
    format : Texture_Format,
    width : u32,
    height : u32,
    presentMode : Present_Mode,
}

Texture_Binding_Layout :: struct {
    sampleType : Texture_Sample_Type,
    viewDimension : Texture_View_Dimension,
    multisampled : bool,
}

Texture_Data_Layout :: struct {
    offset : uint,
    bytesPerRow : u32,
    rowsPerImage : u32,
}

Texture_View_Descriptor :: struct {
    label : string,
    format : Texture_Format,
    dimension : Texture_View_Dimension,
    baseMipLevel : u32,
    mipLevelCount : u32,
    baseArrayLayer : u32,
    arrayLayerCount : u32,
    aspect : Texture_Aspect,
}

Vertex_Attribute :: struct {
    format : Vertex_Format,
    offset : uint,
    shaderLocation : u32,
}

Bind_Group_Descriptor :: struct {
    label : string,
    layout : Bind_Group_Layout,
    entries : []Bind_Group_Entry,
}

Bind_Group_Layout_Entry :: struct {
    binding : u32,
    visibility : []Shader_Stage,
    buffer : Buffer_Binding_Layout,
    sampler : Sampler_Binding_Layout,
    texture : Texture_Binding_Layout,
    storageTexture : Storage_Texture_Binding_Layout,
}

Blend_State :: struct {
    color : Blend_Component,
    alpha : Blend_Component,
}

Compilation_Info :: struct {
    messages : []Compilation_Message,
}

Depth_Stencil_State :: struct {
    format : Texture_Format,
    depthWriteEnabled : bool,
    depthCompare : Compare_Function,
    stencilFront : Stencil_Face_State,
    stencilBack : Stencil_Face_State,
    stencilReadMask : u32,
    stencilWriteMask : u32,
    depthBias : i32,
    depthBiasSlopeScale : f32,
    depthBiasClamp : f32,
}

Image_Copy_Buffer :: struct {
    layout : Texture_Data_Layout,
    buffer : Buffer,
}

Image_Copy_Texture :: struct {
    texture : Texture,
    mipLevel : u32,
    origin : Origin_3D,
    aspect : Texture_Aspect,
}

Programmable_Stage_Descriptor :: struct {
    module : Shader_Module,
    entryPoint : cstring,
    constants : []Constant_Entry,
}

Render_Pass_Color_Attachment :: struct {
    view : Texture_View,
    resolveTarget : Texture_View,
    loadOp : Load_Op,
    storeOp : Store_Op,
    clearColor : Color,
}

Required_Limits :: struct {
    limits : Limits,
}

Supported_Limits :: struct {
    limits : Limits,
}

Texture_Descriptor :: struct {
    label : string,
    usage : []Texture_Usage,
    dimension : Texture_Dimension,
    size : Extent_3D,
    format : Texture_Format,
    mipLevelCount : u32,
    sampleCount : u32,
}

Vertex_Buffer_Layout :: struct {
    arrayStride : uint,
    stepMode : Vertex_Step_Mode,
    attributes : []Vertex_Attribute,
}

Bind_Group_Layout_Descriptor :: struct {
    label : string,
    entries : []Bind_Group_Layout_Entry,
}

Color_Target_State :: struct {
    format : Texture_Format,
    blend : ^Blend_State,
    writeMask : []Color_Write_Mask,
}

Compute_Pipeline_Descriptor :: struct {
    label : string,
    layout : Pipeline_Layout,
    compute : Programmable_Stage_Descriptor,
}

Device_Descriptor :: struct {
    requiredFeatures : []Feature_Name,
    requiredLimits : ^Required_Limits,
}

Render_Pass_Descriptor :: struct {
    label : string,
    colorAttachments : []Render_Pass_Color_Attachment,
    depthStencilAttachment : ^Render_Pass_Depth_Stencil_Attachment,
    occlusionQuerySet : Query_Set,
}

Vertex_State :: struct {
    module : Shader_Module,
    entryPoint : string,
    constantCount : u32,
    constants : ^Constant_Entry,
    bufferCount : u32,
    buffers : ^Vertex_Buffer_Layout,
}

Fragment_State :: struct {
    module : Shader_Module,
    entryPoint : string,
    constants : []Constant_Entry,
    targets : []Color_Target_State,
}

Render_Pipeline_Descriptor :: struct {
    label : string,
    layout : Pipeline_Layout,
    vertex : Vertex_State,
    primitive : Primitive_State,
    depthStencil : ^Depth_Stencil_State,
    multisample : Multisample_State,
    fragment : ^Fragment_State,
}

adapter_get_limits :: n.AdapterGetLimits

adapter_get_properties :: n.AdapterGetProperties

adapter_has_feature :: n.AdapterHasFeature

adapter_request_device :: proc(
    adapter: Adapter,
    descriptor: ^Device_Descriptor,
    callback: Request_Device_Callback,
    userdata: rawptr,
) {
    Userdata_Wrapper :: struct {
        callback: Request_Device_Callback,
        userdata: rawptr,
    }

    // Call the callback from the native callback
    adapter_request_callback_n := proc(
        status : n.RequestDeviceStatus,
        device : n.Device,
        message : cstring,
        userdata : rawptr,
    ){
        u := cast(^Userdata_Wrapper)userdata
        u.callback(status, device, string(message), u.userdata)
    }

    n.AdapterRequestDevice(adapter,
        &n.DeviceDescriptor{
            requiredFeaturesCount = u32(len(descriptor.requiredFeatures)),
            requiredFeatures = &descriptor.requiredFeatures[0],
            requiredLimits = &n.RequiredLimits{
                limits = descriptor.requiredLimits.limits,
            },
        },
        adapter_request_callback_n,
        &Userdata_Wrapper{callback, userdata},
    )
}

buffer_destroy :: n.BufferDestroy

buffer_get_const_mapped_range :: proc(
        buffer : Buffer,
        offset : uint,
        size : uint,
    ) -> rawptr {
        return n.BufferGetConstMappedRange(buffer, offset, size)
}

buffer_get_mapped_range :: proc(
        buffer : Buffer,
        offset : uint,
        size : uint,
    ) -> rawptr {
        return n.BufferGetMappedRange(buffer, offset, size)
}

buffer_map_async :: proc(
    buffer : Buffer,
    mode : []Map_Mode,
    offset : uint,
    size : uint,
    callback : Buffer_Map_Callback,
    userdata : rawptr,
) {
    mode_flags := u32(0)
    for i := 0; i < len(mode); i += 1 {
        mode_flags |= u32(mode[i])
    }
    n.BufferMapAsync(buffer,
                     mode_flags,
                     offset,
                     size,
                     callback,
                     userdata)
}

buffer_unmap :: n.BufferUnmap

command_encoder_begin_computepass :: proc(
        commandEncoder : Command_Encoder,
        label: string,
    ) -> Compute_Pass_Encoder {
        c_label := strings.clone_to_cstring(label,
                                            context.temp_allocator)

        return n.CommandEncoderBeginComputePass(
            commandEncoder,
            &n.ComputePassDescriptor {
                label = c_label,
            },
        )
}

command_encoder_begin_renderpass :: proc(
        commandEncoder : Command_Encoder,
        descriptor : ^Render_Pass_Descriptor,
    ) -> RenderPass_Encoder {
        c_label := strings.clone_to_cstring(descriptor.label,
                                            context.temp_allocator)

        return n.CommandEncoderBeginRenderPass(
            commandEncoder,
            &n.RenderPassDescriptor{
                label = c_label,
                colorAttachmentCount = u32(len(descriptor.colorAttachments)),
                colorAttachments = &descriptor.colorAttachments[0],
                depthStencilAttachment = descriptor.depthStencilAttachment,
                occlusionQuerySet = descriptor.occlusionQuerySet,
            })
}

Command_Encoder_Copy_Buffer_To_Buffer :: n.CommandEncoderCopyBufferToBuffer

command_encoder_copy_texture_to_buffer :: proc(
    commandEncoder : Command_Encoder,
    source : ^Image_Copy_Texture,
    destination : ^Image_Copy_Buffer,
    copySize : ^Extent_3D,
) {
    n.CommandEncoderCopyTextureToBuffer(commandEncoder,
                                        &Image_Copy_Texture{
                                            texture = source.texture,
                                            mipLevel = source.mipLevel,
                                            origin = source.origin,
                                            aspect = source.aspect,
                                        },
                                        &Image_Copy_Buffer {
                                            buffer = destination.buffer,
                                            layout = destination.layout,
                                        },
                                        copySize)
}

command_encoder_copy_texture_to_texture :: proc(
        commandEncoder : CommandEncoder,
        source : ^ImageCopyTexture,
        destination : ^ImageCopyTexture,
        copySize : ^Extent3D,
) {
    n.CommandEncoderCopyTextureToBuffer(commandEncoder,
                                        &Image_Copy_Texture{
                                            texture = source.texture,
                                            mipLevel = source.mipLevel,
                                            origin = source.origin,
                                            aspect = source.aspect,
                                        },
                                        &Image_Copy_Texture{
                                            texture = destination.texture,
                                            mipLevel = destination.mipLevel,
                                            origin = destination.origin,
                                            aspect = destination.aspect,
                                        },
                                        copySize)

}

command_encoder_finish :: proc(
    commandEncoder : Command_Encoder,
    descriptor : ^Command_Buffer_Descriptor,
) -> Command_Buffer {
    c_label := strings.clone_to_cstring(descriptor.label,
                                        context.temp_allocator)

    return n.CommandEncoderFinish(commandEncoder,
                           &n.CommandBufferDescriptor {
                               label = c_label,
                           },
    )
}

command_encoder_insert_debug_marker :: proc(
    command_encoder : Command_Encoder,
    marker_label : string,
) {
    c_marker_label := strings.clone_to_cstring(marker_label,
                                               context.temp_allocator)

    n.CommandEncoderInsertDebugMarker(command_encoder, c_marker_label)
}

command_encoder_pop_debug_group :: proc(
    command_encoder : Command_Encoder,
) {
    n.CommandEncoderPopDebugGroup(command_encoder)
}

command_encoder_push_debug_group :: proc(
        command_encoder : Command_Encoder,
        group_label : string,
) {
    c_group_label := strings.clone_to_cstring(group_label,
                                              context.temp_allocator)

    n.CommandEncoderPushDebugGroup(command_encoder, c_group_label)
}

command_encoder_resolve_query_set :: n.CommandEncoderResolveQuerySet

command_encoder_write_timestamp :: n.CommandEncoderWriteTimestamp

compute_pass_encoder_begin_pipeline_statistics_query :: n.ComputePassEncoderBeginPipelineStatisticsQuery

compute_pass_encoder_dispatch :: n.ComputePassEncoderDispatch

compute_pass_encoder_dispatch_indirect :: n.ComputePassEncoderDispatchIndirect

compute_pass_encoder_end_pass :: n.ComputePassEncoderEndPass

ComputePassEncoderEndPipelineStatisticsQuery :: n.ComputePassEncoderEndPipelineStatisticsQuery

compute_pass_encoder_insert_debug_marker :: proc(
    compute_pass_encoder : Compute_Pass_Encoder,
    marker_label : string,
) {
    c_marker_label := strings.clone_to_cstring(marker_label,
                                              context.temp_allocator)

    n.ComputePassEncoderInsertDebugMarker(compute_pass_encoder, c_marker_label)
}

compute_pass_encoder_pop_debug_group :: n.ComputePassEncoderPopDebugGroup

Compute_Pass_Encoder_Push_Debug_Group :: proc(
    compute_pass_encoder : Compute_Pass_Encoder,
    group_label : string,
) {
    c_group_label := strings.clone_to_cstring(group_label,
                                              context.temp_allocator)

    n.ComputePassEncoderPushDebugGroup(compute_pass_encoder,
                                       c_group_label)
}

    ComputePassEncoderSetBindGroup :: proc(
        computePassEncoder : ComputePassEncoder,
        groupIndex : u32,
        group : BindGroup,
        dynamicOffsetCount : u32,
        dynamicOffsets : ^u32,
    ) ---

    ComputePassEncoderSetPipeline :: proc(
        computePassEncoder : ComputePassEncoder,
        pipeline : ComputePipeline,
    ) ---

    ComputePassEncoderWriteTimestamp :: proc(
        computePassEncoder : ComputePassEncoder,
        querySet : QuerySet,
        queryIndex : u32,
    ) ---

    ComputePipelineGetBindGroupLayout :: proc(
        computePipeline : ComputePipeline,
        groupIndex : u32,
    ) -> BindGroupLayout ---

    ComputePipelineSetLabel :: proc(
        computePipeline : ComputePipeline,
        label : cstring,
    ) ---


