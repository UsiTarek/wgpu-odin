package wgpu

import "core:mem"

@(private="file")
slice_to_ptr :: proc (
    slice: []$T,
) -> (^T, uint) {
    if (len(slice) != 0) {
        return &slice[0], len(slice)
    }
    return nil, 0
}

DeviceDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    requiredFeatures : []FeatureName,
    requiredLimits : ^RequiredLimits,
}

RenderPassDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    colorAttachments : []RenderPassColorAttachment,
    depthStencilAttachment : ^RenderPassDepthStencilAttachment,
    occlusionQuerySet : QuerySet,
}

PipelineLayoutDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    bindGroupLayouts : []BindGroupLayout,
}

QuerySetDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    type : QueryType,
    count : u32,
    pipelineStatistics : []PipelineStatisticName,
}

RenderBundleEncoderDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    colorFormats : []TextureFormat,
    depthStencilFormat : TextureFormat,
    sampleCount : u32,
}

BindGroupDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    layout : BindGroupLayout,
    entries : []BindGroupEntry,
}

BindGroupLayoutDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    entries : []BindGroupLayoutEntry,
}

ProgrammableStageDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    module : ShaderModule,
    entryPoint : cstring,
    constantCount : u32,
    constants : []ConstantEntry,
}

ComputePipelineDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    layout : PipelineLayout,
    compute : ProgrammableStageDescriptor,
}

VertexBufferLayout :: struct {
    arrayStride : u64,
    stepMode : VertexStepMode,
    attributes : []VertexAttribute,
}

VertexState :: struct {
    nextInChain : ^ChainedStruct,
    module : ShaderModule,
    entryPoint : cstring,
    constants : []ConstantEntry,
    buffers : []VertexBufferLayout,
}

FragmentState :: struct {
    nextInChain : ^ChainedStruct,
    module : ShaderModule,
    entryPoint : cstring,
    constants : []ConstantEntry,
    targets : []ColorTargetState,
}

RenderPipelineDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    layout : PipelineLayout,
    vertex : VertexState,
    primitive : PrimitiveState,
    depthStencil : ^DepthStencilState,
    multisample : MultisampleState,
    fragment : ^FragmentState,
}

@(private)
DeviceCreateRenderPipelineSlice :: proc(
        device : Device,
        descriptor : ^RenderPipelineDescriptor,
) -> RenderPipeline {
    fragment: ^FragmentStateC = nil
    if descriptor.fragment != nil {
        fragmentSlice := descriptor.fragment
        constants, constantCount := slice_to_ptr(descriptor.fragment.constants)
        targets, targetCount := slice_to_ptr(descriptor.fragment.targets)
        
        fragment = &FragmentStateC{
            nextInChain = fragmentSlice.nextInChain,
            module = fragmentSlice.module,
            entryPoint = fragmentSlice.entryPoint,
            constantCount = auto_cast constantCount,
            constants = constants,
            targetCount = auto_cast targetCount,
            targets = targets,
        }
    }
    
    // Vertex State
    vertex: VertexStateC = {}
    {
        constants, constantCount := slice_to_ptr(descriptor.vertex.constants)
        
        bufferCount := len(descriptor.vertex.buffers)
        buffersSlice := make([]VertexBufferLayoutC, auto_cast bufferCount, context.temp_allocator)
        if bufferCount != 0 {
            for bufferLayout, i in descriptor.vertex.buffers {
            attributes, attributeCount := slice_to_ptr(descriptor.vertex.buffers[i].attributes)
                buffersSlice[i] = VertexBufferLayoutC{
                    arrayStride = descriptor.vertex.buffers[i].arrayStride,
                    stepMode = descriptor.vertex.buffers[i].stepMode,
                    attributeCount = auto_cast attributeCount,
                    attributes = attributes,
                }
            }
        }
        
        buffers, _ := slice_to_ptr(buffersSlice)
        vertex = VertexStateC{
            nextInChain = descriptor.vertex.nextInChain,
            module = descriptor.vertex.module,
            entryPoint = descriptor.vertex.entryPoint,
            constantCount = auto_cast constantCount,
            constants = constants,
            bufferCount = auto_cast bufferCount, 
            buffers = buffers,
        }
    }
    
    return DeviceCreateRenderPipeline(
        device,
        &RenderPipelineDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            layout = descriptor.layout,
            vertex = vertex,
            primitive = descriptor.primitive,
            depthStencil = descriptor.depthStencil,
            multisample = descriptor.multisample,
            fragment = fragment,
        },
    )
}

@(private)
DeviceCreateRenderPipelineAsyncSlice :: proc(
    device : Device,
    descriptor : ^RenderPipelineDescriptor,
    callback : CreateRenderPipelineAsyncCallback,
    userdata : rawptr,
) {
    fragment: ^FragmentStateC = nil
    if descriptor.fragment != nil {
        fragmentSlice := descriptor.fragment
        constants, constantCount := slice_to_ptr(descriptor.fragment.constants)
        targets, targetCount := slice_to_ptr(descriptor.fragment.targets)
        
        fragment = &FragmentStateC{
            nextInChain = fragmentSlice.nextInChain,
            module = fragmentSlice.module,
            entryPoint = fragmentSlice.entryPoint,
            constantCount = auto_cast constantCount,
            constants = constants,
            targetCount = auto_cast targetCount,
            targets = targets,
        }
    }
    
    // Vertex State
    vertex: VertexStateC = {}
    {
        constants, constantCount := slice_to_ptr(descriptor.vertex.constants)
        
        bufferCount := len(descriptor.vertex.buffers)
        buffersSlice := make([]VertexBufferLayoutC, auto_cast bufferCount, context.temp_allocator)
        if bufferCount != 0 {
            for bufferLayout, i in descriptor.vertex.buffers {
            attributes, attributeCount := slice_to_ptr(descriptor.vertex.buffers[i].attributes)
                buffersSlice[i] = VertexBufferLayoutC{
                    arrayStride = descriptor.vertex.buffers[i].arrayStride,
                    stepMode = descriptor.vertex.buffers[i].stepMode,
                    attributeCount = auto_cast attributeCount,
                    attributes = attributes,
                }
            }
        }
        
        buffers, _ := slice_to_ptr(buffersSlice)
        vertex = VertexStateC{
            nextInChain = descriptor.vertex.nextInChain,
            module = descriptor.vertex.module,
            entryPoint = descriptor.vertex.entryPoint,
            constantCount = auto_cast constantCount,
            constants = constants,
            bufferCount = auto_cast bufferCount, 
            buffers = buffers,
        }
    }
    
    DeviceCreateRenderPipelineAsync(
        device,
        &RenderPipelineDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            layout = descriptor.layout,
            vertex = vertex,
            primitive = descriptor.primitive,
            depthStencil = descriptor.depthStencil,
            multisample = descriptor.multisample,
            fragment = fragment,
        },
        callback,
        userdata,
    )
}

@(private)
DeviceCreateBindGroupSlice :: proc(
    device : Device,
    descriptor : ^BindGroupDescriptor,
) -> BindGroup {
    entries, entriesCount := slice_to_ptr(descriptor.entries)
    
    return DeviceCreateBindGroupC(
        device,
        &BindGroupDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            layout = descriptor.layout,
            entryCount = auto_cast entriesCount,
            entries = entries,
        },
    )
}

@(private)
DeviceCreateRenderBundleEncoderSlice :: proc(
        device : Device,
        descriptor : ^RenderBundleEncoderDescriptor,
) -> RenderBundleEncoder {
    colorFormats, colorFormatsCount := slice_to_ptr(descriptor.colorFormats)
    
    return DeviceCreateRenderBundleEncoderC(
        device = device,
        descriptor = &RenderBundleEncoderDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            colorFormatsCount = auto_cast colorFormatsCount,
            colorFormats = colorFormats,
            depthStencilFormat = descriptor.depthStencilFormat,
            sampleCount = descriptor.sampleCount,
        },
    )

}

@(private)
DeviceCreateQuerySetSlice :: proc(
        device : Device,
        descriptor : ^QuerySetDescriptor,
) -> QuerySet {
    pipStats, pipStatCount := slice_to_ptr(descriptor.pipelineStatistics)

    return DeviceCreateQuerySetC(
        device,
        &QuerySetDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            type = descriptor.type,
            count = descriptor.count,
            pipelineStatisticsCount = auto_cast pipStatCount,
            pipelineStatistics = pipStats,
        },
    )
}

@(private)
QueueSubmitSlice :: proc(
        queue : Queue,
        commands : []CommandBuffer,
) {
    cmds, cmdCount := slice_to_ptr(commands)
   
    free_all(context.temp_allocator)
    QueueSubmit(
        queue,
        auto_cast cmdCount,
        cmds,
    )
}

@(private)
ComputePassEncoderSetBindGroupSlice :: proc(
    computePassEncoder : ComputePassEncoder,
    groupIndex : u32,
    group : BindGroup,
    dynamicOffsets : []u32,
) {
    dynOffsets, dynOffsetCount := slice_to_ptr(dynamicOffsets)
    
    ComputePassEncoderSetBindGroup(
        computePassEncoder,
        groupIndex,
        group,
        auto_cast dynOffsetCount,
        dynOffsets,
    )
}

@(private)
DeviceCreatePipelineLayoutSlice :: proc(
        device : Device,
        descriptor : ^PipelineLayoutDescriptor,
) -> PipelineLayout {

    bindGroupLayouts, bindGroupLayoutCount := slice_to_ptr(descriptor.bindGroupLayouts)

    return DeviceCreatePipelineLayoutC(
        device,
        &PipelineLayoutDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            bindGroupLayoutCount = auto_cast bindGroupLayoutCount,
            bindGroupLayouts = bindGroupLayouts,
        },
    )
}

@(private)
DeviceCreateBindGroupLayoutSlice :: proc(
    device : Device,
    descriptor : ^BindGroupLayoutDescriptor,
) -> BindGroupLayout {
    entries, entriesCount := slice_to_ptr(descriptor.entries)
    
    return DeviceCreateBindGroupLayoutC(
        device,
        &BindGroupLayoutDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            entryCount = auto_cast entriesCount,
            entries = entries,
        },
    )
}

@(private)
DeviceCreateComputePipelineSlice :: proc(
        device : Device,
        descriptor : ^ComputePipelineDescriptor,
) -> ComputePipeline {
    constants, constantCount := slice_to_ptr(descriptor.compute.constants)
    
    return DeviceCreateComputePipelineC(
        device,
        &ComputePipelineDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            layout = descriptor.layout,
            compute = ProgrammableStageDescriptorC{
                nextInChain = descriptor.compute.nextInChain,
                module = descriptor.compute.module,
                entryPoint = descriptor.compute.entryPoint,
                constantCount = auto_cast constantCount,
                constants = constants,
            },
        },
    )
}

@(private)
DeviceCreateComputePipelineAsyncSlice :: proc(
    device : Device,
    descriptor : ^ComputePipelineDescriptor,
    callback : CreateComputePipelineAsyncCallback,
    userdata : rawptr,
) {
    constants, constantCount := slice_to_ptr(descriptor.compute.constants)

    DeviceCreateComputePipelineAsyncC(
        device,
        &ComputePipelineDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            layout = descriptor.layout,
            compute = ProgrammableStageDescriptorC{
                nextInChain = descriptor.compute.nextInChain,
                module = descriptor.compute.module,
                entryPoint = descriptor.compute.entryPoint,
                constantCount = auto_cast constantCount,
                constants = constants,
            },
        },
        callback,
        userdata,
   )
}

@(private)
AdapterRequestDeviceSlice :: proc(
        adapter : Adapter,
        descriptor : ^DeviceDescriptor,
        callback : RequestDeviceCallback,
        userdata : rawptr,
) {
    requiredFeatures, requiredFeaturesCount := slice_to_ptr(descriptor.requiredFeatures)
    
    AdapterRequestDeviceC(
        adapter,
        &DeviceDescriptorC{
            nextInChain = descriptor.nextInChain,
            requiredFeaturesCount = auto_cast requiredFeaturesCount,
            requiredFeatures = requiredFeatures,
            requiredLimits = descriptor.requiredLimits,
        },
        callback,
        userdata,
    )
}

@(private)
CommandEncoderBeginRenderPassSlice :: proc(
    commandEncoder : CommandEncoder,
    descriptor : ^RenderPassDescriptor,
) -> RenderPassEncoder {
    colorAttachments, colorAttachmentCount := slice_to_ptr(descriptor.colorAttachments)

    return CommandEncoderBeginRenderPassC(
        commandEncoder,
        &RenderPassDescriptorC{
            nextInChain = descriptor.nextInChain,
            label = descriptor.label,
            colorAttachmentCount = auto_cast colorAttachmentCount,
            colorAttachments = colorAttachments,
            depthStencilAttachment = descriptor.depthStencilAttachment,
            occlusionQuerySet = descriptor.occlusionQuerySet,
        },
    )
}

AdapterRequestDevice :: proc {
    AdapterRequestDeviceSlice,
    AdapterRequestDeviceC,
}

DeviceCreateRenderPipeline :: proc {
    DeviceCreateRenderPipelineSlice,
    DeviceCreateRenderPipelineC,
}

DeviceCreateRenderPipelineAsync :: proc {
    DeviceCreateRenderPipelineAsyncSlice,
    DeviceCreateRenderPipelineAsyncC,
}

DeviceCreateBindGroup :: proc {
    DeviceCreateBindGroupSlice,
    DeviceCreateBindGroupC,
}

DeviceCreateRenderBundleEncoder :: proc {
    DeviceCreateRenderBundleEncoderSlice,
    DeviceCreateRenderBundleEncoderC,
}

DeviceCreateQuerySet :: proc {
    DeviceCreateQuerySetSlice,
    DeviceCreateQuerySetC,
}

DeviceCreateBindGroupLayout :: proc {
    DeviceCreateBindGroupLayoutSlice,
    DeviceCreateBindGroupLayoutC,
}

QueueSubmit :: proc {
    QueueSubmitSlice,
    QueueSubmitC,
}

ComputePassEncoderSetBindGroup :: proc {
    ComputePassEncoderSetBindGroupSlice,
    ComputePassEncoderSetBindGroupC,
}

CommandEncoderBeginRenderPass :: proc {
    CommandEncoderBeginRenderPassSlice,
    CommandEncoderBeginRenderPassC,
}

DeviceCreatePipelineLayout :: proc {
    DeviceCreatePipelineLayoutSlice,
    DeviceCreatePipelineLayoutC,
}

DeviceCreateComputePipeline :: proc {
    DeviceCreateComputePipelineSlice,
    DeviceCreateComputePipelineC,
}

DeviceCreateComputePipelineAsync :: proc {
    DeviceCreateComputePipelineAsyncSlice,
    DeviceCreateComputePipelineAsyncC,
}

SwapChainPresent :: proc(swapChain : SwapChain) {
    SwapChainPresentC(swapChain)
    free_all(context.temp_allocator)
}