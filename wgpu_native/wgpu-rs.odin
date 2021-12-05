package wgpu_native

foreign import wgpu "system:wgpu_native"

import _c "core:c"

_H_ :: 1

LogCallback :: #type proc(
    level : LogLevel,
    msg : cstring,
)

NativeSType :: enum i32 {
    DeviceExtras = 1610612737,
    AdapterExtras = 1610612738,
}

NativeFeature :: enum i32 {
    TEXTURE_ADAPTER_SPECIFIC_FORMAT_FEATURES = 268435456,
}

LogLevel :: enum i32 {
    Off = 0,
    Error = 1,
    Warn = 2,
    Info = 3,
    Debug = 4,
    Trace = 5,
}

AdapterExtras :: struct {
    chain : ChainedStruct,
    backend : BackendType,
}

DeviceExtras :: struct {
    chain : ChainedStruct,
    nativeFeatures : NativeFeature,
    label : cstring,
    tracePath : cstring,
}

@(default_calling_convention="c", link_prefix="wgpu")
foreign wgpu {

    DevicePoll :: proc(
        device : Device,
        force_wait : bool,
    ) ---

    SetLogCallback :: proc(callback : LogCallback) ---

    SetLogLevel :: proc(level : LogLevel) ---

    GetVersion :: proc() -> u32 ---

    RenderPassEncoderSetPushConstants :: proc(
        encoder : RenderPassEncoder,
        stages : ShaderStage,
        offset : u32,
        sizeBytes : u32,
        data : rawptr,
    ) ---

    BufferDrop :: proc(buffer : Buffer) ---

    CommandEncoderDrop :: proc(commandEncoder : CommandEncoder) ---

    DeviceDrop :: proc(device : Device) ---

    QuerySetDrop :: proc(querySet : QuerySet) ---

    RenderPipelineDrop :: proc(renderPipeline : RenderPipeline) ---

    TextureDrop :: proc(texture : Texture) ---

    TextureViewDrop :: proc(textureView : TextureView) ---

    SamplerDrop :: proc(sampler : Sampler) ---

    BindGroupLayoutDrop :: proc(bindGroupLayout : BindGroupLayout) ---

    PipelineLayoutDrop :: proc(pipelineLayout : PipelineLayout) ---

    BindGroupDrop :: proc(bindGroup : BindGroup) ---

    ShaderModuleDrop :: proc(shaderModule : ShaderModule) ---

    CommandBufferDrop :: proc(commandBuffer : CommandBuffer) ---

    RenderBundleDrop :: proc(renderBundle : RenderBundle) ---

    ComputePipelineDrop :: proc(computePipeline : ComputePipeline) ---
}
