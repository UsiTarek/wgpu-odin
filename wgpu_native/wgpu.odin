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
    Force32 = 2147483647,
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
    Force32 = 2147483647,
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

@(default_calling_convention="c")
foreign wgpu {

    @(link_name="wgpuDevicePoll")
    DevicePoll :: proc(
        device : Device,
        force_wait : bool,
    ) ---

    @(link_name="wgpuSetLogCallback")
    SetLogCallback :: proc(callback : LogCallback) ---

    @(link_name="wgpuSetLogLevel")
    SetLogLevel :: proc(level : LogLevel) ---

    @(link_name="wgpuGetVersion")
    GetVersion :: proc() -> u32 ---

    @(link_name="wgpuRenderPassEncoderSetPushConstants")
    RenderPassEncoderSetPushConstants :: proc(
        encoder : RenderPassEncoder,
        stages : ShaderStage,
        offset : u32,
        sizeBytes : u32,
        data : rawptr,
    ) ---

    @(link_name="wgpuBufferDrop")
    BufferDrop :: proc(buffer : Buffer) ---

    @(link_name="wgpuCommandEncoderDrop")
    CommandEncoderDrop :: proc(commandEncoder : CommandEncoder) ---

    @(link_name="wgpuDeviceDrop")
    DeviceDrop :: proc(device : Device) ---

    @(link_name="wgpuQuerySetDrop")
    QuerySetDrop :: proc(querySet : QuerySet) ---

    @(link_name="wgpuRenderPipelineDrop")
    RenderPipelineDrop :: proc(renderPipeline : RenderPipeline) ---

    @(link_name="wgpuTextureDrop")
    TextureDrop :: proc(texture : Texture) ---

    @(link_name="wgpuTextureViewDrop")
    TextureViewDrop :: proc(textureView : TextureView) ---

    @(link_name="wgpuSamplerDrop")
    SamplerDrop :: proc(sampler : Sampler) ---

    @(link_name="wgpuBindGroupLayoutDrop")
    BindGroupLayoutDrop :: proc(bindGroupLayout : BindGroupLayout) ---

    @(link_name="wgpuPipelineLayoutDrop")
    PipelineLayoutDrop :: proc(pipelineLayout : PipelineLayout) ---

    @(link_name="wgpuBindGroupDrop")
    BindGroupDrop :: proc(bindGroup : BindGroup) ---

    @(link_name="wgpuShaderModuleDrop")
    ShaderModuleDrop :: proc(shaderModule : ShaderModule) ---

    @(link_name="wgpuCommandBufferDrop")
    CommandBufferDrop :: proc(commandBuffer : CommandBuffer) ---

    @(link_name="wgpuRenderBundleDrop")
    RenderBundleDrop :: proc(renderBundle : RenderBundle) ---

    @(link_name="wgpuComputePipelineDrop")
    ComputePipelineDrop :: proc(computePipeline : ComputePipeline) ---

}
