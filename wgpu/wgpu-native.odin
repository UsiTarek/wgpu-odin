package wgpu

 // -lwgpu_native
when ODIN_OS == .Windows {
    foreign import lib "wgpu_native.lib"
}else {
    foreign import lib "system:wgpu_native"
}

import _c "core:c"

Handle :: rawptr
Adapter :: Handle 
BindGroup :: Handle
BindGroupLayout :: Handle
Buffer :: Handle
CommandBuffer :: Handle
CommandEncoder :: Handle
ComputePassEncoder :: Handle
ComputePipeline :: Handle
Device :: Handle
Instance :: Handle
PipelineLayout :: Handle
QuerySet :: Handle
Queue :: Handle
RenderBundle :: Handle
RenderBundleEncoder :: Handle
RenderPassEncoder :: Handle
RenderPipeline :: Handle
Sampler :: Handle
ShaderModule :: Handle
Surface :: Handle
SwapChain :: Handle
Texture :: Handle
TextureView :: Handle

BufferMapCallback :: #type proc(
    status : BufferMapAsyncStatus,
    userdata : rawptr,
)

CreateComputePipelineAsyncCallback :: #type proc(
    status : CreatePipelineAsyncStatus,
    pipeline : ComputePipeline,
    message : cstring,
    userdata : rawptr,
)

CreateRenderPipelineAsyncCallback :: #type proc(
    status : CreatePipelineAsyncStatus,
    pipeline : RenderPipeline,
    message : cstring,
    userdata : rawptr,
)

DeviceLostCallback :: #type proc(
    reason : DeviceLostReason,
    message : cstring,
    userdata : rawptr,
)

ErrorCallback :: #type proc(
    type : ErrorType,
    message : cstring,
    userdata : rawptr,
)

QueueWorkDoneCallback :: #type proc(
    status : QueueWorkDoneStatus,
    userdata : rawptr,
)

RequestAdapterCallback :: #type proc(
    status : RequestAdapterStatus,
    adapter : Adapter,
    message : cstring,
    userdata : rawptr,
)

RequestDeviceCallback :: #type proc(
    status : RequestDeviceStatus,
    device : Device,
    message : cstring,
    userdata : rawptr,
)

Proc :: #type proc()

AdapterType :: enum i32 {
    DiscreteGPU = 0,
    IntegratedGPU = 1,
    CPU = 2,
    Unknown = 3,
}

AddressMode :: enum i32 {
    Repeat = 0,
    MirrorRepeat = 1,
    ClampToEdge = 2,
}

BackendType :: enum i32 {
    Null = 0,
    WebGPU = 1,
    D3D11 = 2,
    D3D12 = 3,
    Metal = 4,
    Vulkan = 5,
    OpenGL = 6,
    OpenGLES = 7,
}

BlendFactor :: enum i32 {
    Zero = 0,
    One = 1,
    Src = 2,
    OneMinusSrc = 3,
    SrcAlpha = 4,
    OneMinusSrcAlpha = 5,
    Dst = 6,
    OneMinusDst = 7,
    DstAlpha = 8,
    OneMinusDstAlpha = 9,
    SrcAlphaSaturated = 10,
    Constant = 11,
    OneMinusConstant = 12,
}

BlendOperation :: enum i32 {
    Add = 0,
    Subtract = 1,
    ReverseSubtract = 2,
    Min = 3,
    Max = 4,
}

BufferBindingType :: enum i32 {
    Undefined = 0,
    Uniform = 1,
    Storage = 2,
    ReadOnlyStorage = 3,
}

BufferMapAsyncStatus :: enum i32 {
    Success = 0,
    Error = 1,
    Unknown = 2,
    DeviceLost = 3,
    DestroyedBeforeCallback = 4,
    UnmappedBeforeCallback = 5,
}

CompareFunction :: enum i32 {
    Undefined = 0,
    Never = 1,
    Less = 2,
    LessEqual = 3,
    Greater = 4,
    GreaterEqual = 5,
    Equal = 6,
    NotEqual = 7,
    Always = 8,
}

CompilationMessageType :: enum i32 {
    Error = 0,
    Warning = 1,
    Info = 2,
}

CreatePipelineAsyncStatus :: enum i32 {
    Success = 0,
    Error = 1,
    DeviceLost = 2,
    DeviceDestroyed = 3,
    Unknown = 4,
}

CullMode :: enum i32 {
    None = 0,
    Front = 1,
    Back = 2,
}

DeviceLostReason :: enum i32 {
    Undefined = 0,
    Destroyed = 1,
}

ErrorFilter :: enum i32 {
    None = 0,
    Validation = 1,
    OutOfMemory = 2,
}

ErrorType :: enum i32 {
    NoError = 0,
    Validation = 1,
    OutOfMemory = 2,
    Unknown = 3,
    DeviceLost = 4,
}

FeatureName :: enum i32 {
    Undefined = 0,
    DepthClamping = 1,
    Depth24UnormStencil8 = 2,
    Depth32FloatStencil8 = 3,
    TimestampQuery = 4,
    PipelineStatisticsQuery = 5,
    TextureCompressionBC = 6,
}

FilterMode :: enum i32 {
    Nearest = 0,
    Linear = 1,
}

FrontFace :: enum i32 {
    CCW = 0,
    CW = 1,
}

IndexFormat :: enum i32 {
    Undefined = 0,
    Uint16 = 1,
    Uint32 = 2,
}

LoadOp :: enum i32 {
    Clear = 0,
    Load = 1,
}

PipelineStatisticName :: enum i32 {
    VertexShaderInvocations = 0,
    ClipperInvocations = 1,
    ClipperPrimitivesOut = 2,
    FragmentShaderInvocations = 3,
    ComputeShaderInvocations = 4,
}

PowerPreference :: enum i32 {
    LowPower = 0,
    HighPerformance = 1,
}

PresentMode :: enum i32 {
    Immediate = 0,
    Mailbox = 1,
    Fifo = 2,
}

PrimitiveTopology :: enum i32 {
    PointList = 0,
    LineList = 1,
    LineStrip = 2,
    TriangleList = 3,
    TriangleStrip = 4,
}

QueryType :: enum i32 {
    Occlusion = 0,
    PipelineStatistics = 1,
    Timestamp = 2,
}

QueueWorkDoneStatus :: enum i32 {
    Success = 0,
    Error = 1,
    Unknown = 2,
    DeviceLost = 3,
}

RequestAdapterStatus :: enum i32 {
    Success = 0,
    Unavailable = 1,
    Error = 2,
    Unknown = 3,
}

RequestDeviceStatus :: enum i32 {
    Success = 0,
    Error = 1,
    Unknown = 2,
}

SType :: enum i32 {
    Invalid = 0,
    SurfaceDescriptorFromMetalLayer = 1,
    SurfaceDescriptorFromWindowsHWND = 2,
    SurfaceDescriptorFromXlib = 3,
    SurfaceDescriptorFromCanvasHTMLSelector = 4,
    ShaderModuleSPIRVDescriptor = 5,
    ShaderModuleWGSLDescriptor = 6,
    PrimitiveDepthClampingState = 7,
}

SamplerBindingType :: enum i32 {
    Undefined = 0,
    Filtering = 1,
    NonFiltering = 2,
    Comparison = 3,
}

StencilOperation :: enum i32 {
    Keep = 0,
    Zero = 1,
    Replace = 2,
    Invert = 3,
    IncrementClamp = 4,
    DecrementClamp = 5,
    IncrementWrap = 6,
    DecrementWrap = 7,
}

StorageTextureAccess :: enum i32 {
    Undefined = 0,
    WriteOnly = 1,
}

StoreOp :: enum i32 {
    Store = 0,
    Discard = 1,
}

TextureAspect :: enum i32 {
    All = 0,
    StencilOnly = 1,
    DepthOnly = 2,
}

TextureComponentType :: enum i32 {
    Float = 0,
    Sint = 1,
    Uint = 2,
    DepthComparison = 3,
}

TextureDimension :: enum i32 {
    OneDimensional = 0,
    TwoDimensional = 1,
    ThreeDimensional = 2,
}

TextureFormat :: enum i32 {
    Undefined = 0,
    R8Unorm = 1,
    R8Snorm = 2,
    R8Uint = 3,
    R8Sint = 4,
    R16Uint = 5,
    R16Sint = 6,
    R16Float = 7,
    RG8Unorm = 8,
    RG8Snorm = 9,
    RG8Uint = 10,
    RG8Sint = 11,
    R32Float = 12,
    R32Uint = 13,
    R32Sint = 14,
    RG16Uint = 15,
    RG16Sint = 16,
    RG16Float = 17,
    RGBA8Unorm = 18,
    RGBA8UnormSrgb = 19,
    RGBA8Snorm = 20,
    RGBA8Uint = 21,
    RGBA8Sint = 22,
    BGRA8Unorm = 23,
    BGRA8UnormSrgb = 24,
    RGB10A2Unorm = 25,
    RG11B10Ufloat = 26,
    RGB9E5Ufloat = 27,
    RG32Float = 28,
    RG32Uint = 29,
    RG32Sint = 30,
    RGBA16Uint = 31,
    RGBA16Sint = 32,
    RGBA16Float = 33,
    RGBA32Float = 34,
    RGBA32Uint = 35,
    RGBA32Sint = 36,
    Stencil8 = 37,
    Depth16Unorm = 38,
    Depth24Plus = 39,
    Depth24PlusStencil8 = 40,
    Depth32Float = 41,
    BC1RGBAUnorm = 42,
    BC1RGBAUnormSrgb = 43,
    BC2RGBAUnorm = 44,
    BC2RGBAUnormSrgb = 45,
    BC3RGBAUnorm = 46,
    BC3RGBAUnormSrgb = 47,
    BC4RUnorm = 48,
    BC4RSnorm = 49,
    BC5RGUnorm = 50,
    BC5RGSnorm = 51,
    BC6HRGBUfloat = 52,
    BC6HRGBFloat = 53,
    BC7RGBAUnorm = 54,
    BC7RGBAUnormSrgb = 55,
}

TextureSampleType :: enum i32 {
    Undefined = 0,
    Float = 1,
    UnfilterableFloat = 2,
    Depth = 3,
    Sint = 4,
    Uint = 5,
}

TextureViewDimension :: enum i32 {
    Undefined = 0,
    OneDimensional = 1,
    TwoDimensional = 2,
    TwoDimensionalArray = 3,
    Cube = 4,
    CubeArray = 5,
    ThreeDimensional = 6,
}

VertexFormat :: enum i32 {
    Undefined = 0,
    Uint8x2 = 1,
    Uint8x4 = 2,
    Sint8x2 = 3,
    Sint8x4 = 4,
    Unorm8x2 = 5,
    Unorm8x4 = 6,
    Snorm8x2 = 7,
    Snorm8x4 = 8,
    Uint16x2 = 9,
    Uint16x4 = 10,
    Sint16x2 = 11,
    Sint16x4 = 12,
    Unorm16x2 = 13,
    Unorm16x4 = 14,
    Snorm16x2 = 15,
    Snorm16x4 = 16,
    Float16x2 = 17,
    Float16x4 = 18,
    Float32 = 19,
    Float32x2 = 20,
    Float32x3 = 21,
    Float32x4 = 22,
    Uint32 = 23,
    Uint32x2 = 24,
    Uint32x3 = 25,
    Uint32x4 = 26,
    Sint32 = 27,
    Sint32x2 = 28,
    Sint32x3 = 29,
    Sint32x4 = 30,
}

VertexStepMode :: enum i32 {
    Vertex = 0,
    Instance = 1,
}

BufferUsage :: enum i32 {
    MapRead = 0,
    MapWrite = 1,
    CopySrc = 2,
    CopyDst = 3,
    Index = 4,
    Vertex = 5,
    Uniform = 6,
    Storage = 7,
    Indirect = 8,
    QueryResolve = 9,
}
BufferUsageFlags :: bit_set[BufferUsage; u32]
BufferUsageFlagsNone :: BufferUsageFlags{}

ColorWriteMask :: enum u32 {
    Red = 0,
    Green = 1,
    Blue = 2,
    Alpha = 3,
}
ColorWriteMaskFlags :: bit_set[ColorWriteMask; u32]
ColorWriteMaskFlagsAll :: ColorWriteMaskFlags{ .Red, .Green, .Blue, .Alpha }
ColorWriteMaskFlagsNone :: ColorWriteMaskFlags{ }

MapMode :: enum i32 {
    Read = 0,
    Write = 1,
}
MapModeFlags :: distinct bit_set[MapMode; u32]
MapModeFlagsNone :: MapModeFlags{}

ShaderStage :: enum i32 {
    Vertex = 0,
    Fragment = 1,
    Compute = 2,
}
ShaderStageFlags :: distinct bit_set[ShaderStage; u32]
ShaderStageFlagsNone :: ShaderStageFlags{}

TextureUsage :: enum i32 {
    CopySrc = 0,
    CopyDst = 1,
    TextureBinding = 2,
    StorageBinding = 3,
    RenderAttachment = 4,
}
TextureUsageFlags :: distinct bit_set[TextureUsage; u32]
TextureUsageFlagsNone :: TextureUsageFlags{}

ChainedStruct :: struct {
    next : ^ChainedStruct,
    sType : SType,
}

ChainedStructOut :: struct {
    next : ^ChainedStructOut,
    sType : SType,
}

AdapterProperties :: struct {
    nextInChain : ^ChainedStructOut,
    vendorID : u32,
    deviceID : u32,
    name : cstring,
    driverDescription : cstring,
    adapterType : AdapterType,
    backendType : BackendType,
}

BindGroupEntry :: struct {
    nextInChain : ^ChainedStruct,
    binding : u32,
    buffer : Buffer,
    offset : u64,
    size : u64,
    sampler : Sampler,
    textureView : TextureView,
}

BlendComponent :: struct {
    operation : BlendOperation,
    srcFactor : BlendFactor,
    dstFactor : BlendFactor,
}

BufferBindingLayout :: struct {
    nextInChain : ^ChainedStruct,
    type : BufferBindingType,
    hasDynamicOffset : bool,
    minBindingSize : u64,
}

BufferDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    usage : BufferUsageFlags,
    size : u64,
    mappedAtCreation : bool,
}

Color :: struct {
    r : _c.double,
    g : _c.double,
    b : _c.double,
    a : _c.double,
}

CommandBufferDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
}

CommandEncoderDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
}

CompilationMessage :: struct {
    nextInChain : ^ChainedStruct,
    message : cstring,
    type : CompilationMessageType,
    lineNum : u64,
    linePos : u64,
    offset : u64,
    length : u64,
}

ComputePassDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
}

ConstantEntry :: struct {
    nextInChain : ^ChainedStruct,
    key : cstring,
    value : _c.double,
}

Extent3D :: struct {
    width : u32,
    height : u32,
    depthOrArrayLayers : u32,
}

InstanceDescriptor :: struct {
    nextInChain : ^ChainedStruct,
}

Limits :: struct {
    maxTextureDimension1D : u32,
    maxTextureDimension2D : u32,
    maxTextureDimension3D : u32,
    maxTextureArrayLayers : u32,
    maxBindGroups : u32,
    maxDynamicUniformBuffersPerPipelineLayout : u32,
    maxDynamicStorageBuffersPerPipelineLayout : u32,
    maxSampledTexturesPerShaderStage : u32,
    maxSamplersPerShaderStage : u32,
    maxStorageBuffersPerShaderStage : u32,
    maxStorageTexturesPerShaderStage : u32,
    maxUniformBuffersPerShaderStage : u32,
    maxUniformBufferBindingSize : u64,
    maxStorageBufferBindingSize : u64,
    minUniformBufferOffsetAlignment : u32,
    minStorageBufferOffsetAlignment : u32,
    maxVertexBuffers : u32,
    maxVertexAttributes : u32,
    maxVertexBufferArrayStride : u32,
    maxInterStageShaderComponents : u32,
    maxComputeWorkgroupStorageSize : u32,
    maxComputeInvocationsPerWorkgroup : u32,
    maxComputeWorkgroupSizeX : u32,
    maxComputeWorkgroupSizeY : u32,
    maxComputeWorkgroupSizeZ : u32,
    maxComputeWorkgroupsPerDimension : u32,
}

MultisampleState :: struct {
    nextInChain : ^ChainedStruct,
    count : u32,
    mask : u32,
    alphaToCoverageEnabled : bool,
}

Origin3D :: struct {
    x : u32,
    y : u32,
    z : u32,
}

PipelineLayoutDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    bindGroupLayoutCount : u32,
    bindGroupLayouts : [^]BindGroupLayout,
}

PrimitiveDepthClampingState :: struct {
    chain : ChainedStruct,
    clampDepth : bool,
}

PrimitiveState :: struct {
    nextInChain : ^ChainedStruct,
    topology : PrimitiveTopology,
    stripIndexFormat : IndexFormat,
    frontFace : FrontFace,
    cullMode : CullMode,
}

QuerySetDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    type : QueryType,
    count : u32,
    pipelineStatistics : [^]PipelineStatisticName,
    pipelineStatisticsCount : u32,
}

RenderBundleDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
}

RenderBundleEncoderDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    colorFormatsCount : u32,
    colorFormats : [^]TextureFormat,
    depthStencilFormat : TextureFormat,
    sampleCount : u32,
}

RenderPassDepthStencilAttachment :: struct {
    view : TextureView,
    depthLoadOp : LoadOp,
    depthStoreOp : StoreOp,
    clearDepth : _c.float,
    depthReadOnly : bool,
    stencilLoadOp : LoadOp,
    stencilStoreOp : StoreOp,
    clearStencil : u32,
    stencilReadOnly : bool,
}

RequestAdapterOptions :: struct {
    nextInChain : ^ChainedStruct,
    compatibleSurface : Surface,
    powerPreference : PowerPreference,
    forceFallbackAdapter : bool,
}

SamplerBindingLayout :: struct {
    nextInChain : ^ChainedStruct,
    type : SamplerBindingType,
}

SamplerDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    addressModeU : AddressMode,
    addressModeV : AddressMode,
    addressModeW : AddressMode,
    magFilter : FilterMode,
    minFilter : FilterMode,
    mipmapFilter : FilterMode,
    lodMinClamp : _c.float,
    lodMaxClamp : _c.float,
    compare : CompareFunction,
    maxAnisotropy : u16,
}

ShaderModuleDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
}

ShaderModuleSPIRVDescriptor :: struct {
    chain : ChainedStruct,
    codeSize : u32,
    code : ^u32,
}

ShaderModuleWGSLDescriptor :: struct {
    chain : ChainedStruct,
    source : cstring,
}

StencilFaceState :: struct {
    compare : CompareFunction,
    failOp : StencilOperation,
    depthFailOp : StencilOperation,
    passOp : StencilOperation,
}

StorageTextureBindingLayout :: struct {
    nextInChain : ^ChainedStruct,
    access : StorageTextureAccess,
    format : TextureFormat,
    viewDimension : TextureViewDimension,
}

SurfaceDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
}

SurfaceDescriptorFromCanvasHTMLSelector :: struct {
    chain : ChainedStruct,
    selector : cstring,
}

SurfaceDescriptorFromMetalLayer :: struct {
    chain : ChainedStruct,
    layer : rawptr,
}

SurfaceDescriptorFromWindowsHWND :: struct {
    chain : ChainedStruct,
    hinstance : rawptr,
    hwnd : rawptr,
}

SurfaceDescriptorFromXlib :: struct {
    chain : ChainedStruct,
    display : rawptr,
    window : u32,
}

SwapChainDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    usage : TextureUsageFlags,
    format : TextureFormat,
    width : u32,
    height : u32,
    presentMode : PresentMode,
}

TextureBindingLayout :: struct {
    nextInChain : ^ChainedStruct,
    sampleType : TextureSampleType,
    viewDimension : TextureViewDimension,
    multisampled : bool,
}

TextureDataLayout :: struct {
    nextInChain : ^ChainedStruct,
    offset : u64,
    bytesPerRow : u32,
    rowsPerImage : u32,
}

TextureViewDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    format : TextureFormat,
    dimension : TextureViewDimension,
    baseMipLevel : u32,
    mipLevelCount : u32,
    baseArrayLayer : u32,
    arrayLayerCount : u32,
    aspect : TextureAspect,
}

VertexAttribute :: struct {
    format : VertexFormat,
    offset : u64,
    shaderLocation : u32,
}

BindGroupDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    layout : BindGroupLayout,
    entryCount : u32,
    entries : [^]BindGroupEntry,
}

BindGroupLayoutEntry :: struct {
    nextInChain : ^ChainedStruct,
    binding : u32,
    visibility : ShaderStageFlags,
    buffer : BufferBindingLayout,
    sampler : SamplerBindingLayout,
    texture : TextureBindingLayout,
    storageTexture : StorageTextureBindingLayout,
}

BlendState :: struct {
    color : BlendComponent,
    alpha : BlendComponent,
}

CompilationInfo :: struct {
    nextInChain : ^ChainedStruct,
    messageCount : u32,
    messages : [^]CompilationMessage,
}

DepthStencilState :: struct {
    nextInChain : ^ChainedStruct,
    format : TextureFormat,
    depthWriteEnabled : bool,
    depthCompare : CompareFunction,
    stencilFront : StencilFaceState,
    stencilBack : StencilFaceState,
    stencilReadMask : u32,
    stencilWriteMask : u32,
    depthBias : i32,
    depthBiasSlopeScale : _c.float,
    depthBiasClamp : _c.float,
}

ImageCopyBuffer :: struct {
    nextInChain : ^ChainedStruct,
    layout : TextureDataLayout,
    buffer : Buffer,
}

ImageCopyTexture :: struct {
    nextInChain : ^ChainedStruct,
    texture : Texture,
    mipLevel : u32,
    origin : Origin3D,
    aspect : TextureAspect,
}

ProgrammableStageDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    module : ShaderModule,
    entryPoint : cstring,
    constantCount : u32,
    constants : [^]ConstantEntry,
}

RenderPassColorAttachment :: struct {
    view : TextureView,
    resolveTarget : TextureView,
    loadOp : LoadOp,
    storeOp : StoreOp,
    clearColor : Color,
}

RequiredLimits :: struct {
    nextInChain : ^ChainedStruct,
    limits : Limits,
}

SupportedLimits :: struct {
    nextInChain : ^ChainedStructOut,
    limits : Limits,
}

TextureDescriptor :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    usage : TextureUsageFlags,
    dimension : TextureDimension,
    size : Extent3D,
    format : TextureFormat,
    mipLevelCount : u32,
    sampleCount : u32,
}

VertexBufferLayoutC :: struct {
    arrayStride : u64,
    stepMode : VertexStepMode,
    attributeCount : u32,
    attributes : [^]VertexAttribute,
}

BindGroupLayoutDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    entryCount : u32,
    entries : [^]BindGroupLayoutEntry,
}

ColorTargetState :: struct {
    nextInChain : ^ChainedStruct,
    format : TextureFormat,
    blend : ^BlendState,
    writeMask : ColorWriteMaskFlags,
}

ComputePipelineDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    layout : PipelineLayout,
    compute : ProgrammableStageDescriptorC,
}

DeviceDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    requiredFeaturesCount : u32,
    requiredFeatures : [^]FeatureName,
    requiredLimits : ^RequiredLimits,
}

RenderPassDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    colorAttachmentCount : u32,
    colorAttachments : [^]RenderPassColorAttachment,
    depthStencilAttachment : ^RenderPassDepthStencilAttachment,
    occlusionQuerySet : QuerySet,
}

VertexStateC :: struct {
    nextInChain : ^ChainedStruct,
    module : ShaderModule,
    entryPoint : cstring,
    constantCount : u32,
    constants : [^]ConstantEntry,
    bufferCount : u32,
    buffers : [^]VertexBufferLayoutC,
}

FragmentStateC :: struct {
    nextInChain : ^ChainedStruct,
    module : ShaderModule,
    entryPoint : cstring,
    constantCount : u32,
    constants : ^ConstantEntry,
    targetCount : u32,
    targets : ^ColorTargetState,
}

RenderPipelineDescriptorC :: struct {
    nextInChain : ^ChainedStruct,
    label : cstring,
    layout : PipelineLayout,
    vertex : VertexStateC,
    primitive : PrimitiveState,
    depthStencil : ^DepthStencilState,
    multisample : MultisampleState,
    fragment : ^FragmentStateC,
}

@(default_calling_convention="c", link_prefix="wgpu")
foreign lib {

    CreateInstance :: proc(descriptor : ^InstanceDescriptor) -> Instance ---

    GetProcAddress :: proc(
        device : Device,
        procName : cstring,
    ) -> Proc ---

    AdapterGetLimits :: proc(
        adapter : Adapter,
        limits : ^SupportedLimits,
    ) -> bool ---

    AdapterGetProperties :: proc(
        adapter : Adapter,
        properties : ^AdapterProperties,
    ) ---

    AdapterHasFeature :: proc(
        adapter : Adapter,
        feature : FeatureName,
    ) -> bool ---

    BufferDestroy :: proc(buffer : Buffer) ---

    BufferGetConstMappedRange :: proc(
        buffer : Buffer,
        offset : _c.size_t,
        size : _c.size_t,
    ) -> rawptr ---

    BufferGetMappedRange :: proc(
        buffer : Buffer,
        offset : _c.size_t,
        size : _c.size_t,
    ) -> rawptr ---

    BufferMapAsync :: proc(
        buffer : Buffer,
        mode : MapModeFlags,
        offset : _c.size_t,
        size : _c.size_t,
        callback : BufferMapCallback,
        userdata : rawptr,
    ) ---

    BufferUnmap :: proc(buffer : Buffer) ---

    CommandEncoderBeginComputePass :: proc(
        commandEncoder : CommandEncoder,
        descriptor : ^ComputePassDescriptor,
    ) -> ComputePassEncoder ---

    CommandEncoderCopyBufferToBuffer :: proc(
        commandEncoder : CommandEncoder,
        source : Buffer,
        sourceOffset : u64,
        destination : Buffer,
        destinationOffset : u64,
        size : u64,
    ) ---

    CommandEncoderCopyBufferToTexture :: proc(
        commandEncoder : CommandEncoder,
        source : ^ImageCopyBuffer,
        destination : ^ImageCopyTexture,
        copySize : ^Extent3D,
    ) ---

    CommandEncoderCopyTextureToBuffer :: proc(
        commandEncoder : CommandEncoder,
        source : ^ImageCopyTexture,
        destination : ^ImageCopyBuffer,
        copySize : ^Extent3D,
    ) ---

    CommandEncoderCopyTextureToTexture :: proc(
        commandEncoder : CommandEncoder,
        source : ^ImageCopyTexture,
        destination : ^ImageCopyTexture,
        copySize : ^Extent3D,
    ) ---

    CommandEncoderFinish :: proc(
        commandEncoder : CommandEncoder,
        descriptor : ^CommandBufferDescriptor,
    ) -> CommandBuffer ---

    CommandEncoderInsertDebugMarker :: proc(
        commandEncoder : CommandEncoder,
        markerLabel : cstring,
    ) ---

    CommandEncoderPopDebugGroup :: proc(commandEncoder : CommandEncoder) ---

    CommandEncoderPushDebugGroup :: proc(
        commandEncoder : CommandEncoder,
        groupLabel : cstring,
    ) ---

    CommandEncoderResolveQuerySet :: proc(
        commandEncoder : CommandEncoder,
        querySet : QuerySet,
        firstQuery : u32,
        queryCount : u32,
        destination : Buffer,
        destinationOffset : u64,
    ) ---

    CommandEncoderWriteTimestamp :: proc(
        commandEncoder : CommandEncoder,
        querySet : QuerySet,
        queryIndex : u32,
    ) ---

    ComputePassEncoderBeginPipelineStatisticsQuery :: proc(
        computePassEncoder : ComputePassEncoder,
        querySet : QuerySet,
        queryIndex : u32,
    ) ---

    ComputePassEncoderDispatch :: proc(
        computePassEncoder : ComputePassEncoder,
        x : u32,
        y : u32,
        z : u32,
    ) ---

    ComputePassEncoderDispatchIndirect :: proc(
        computePassEncoder : ComputePassEncoder,
        indirectBuffer : Buffer,
        indirectOffset : u64,
    ) ---

    ComputePassEncoderEndPass :: proc(computePassEncoder : ComputePassEncoder) ---

    ComputePassEncoderEndPipelineStatisticsQuery :: proc(computePassEncoder : ComputePassEncoder) ---

    ComputePassEncoderInsertDebugMarker :: proc(
        computePassEncoder : ComputePassEncoder,
        markerLabel : cstring,
    ) ---

    ComputePassEncoderPopDebugGroup :: proc(computePassEncoder : ComputePassEncoder) ---

    ComputePassEncoderPushDebugGroup :: proc(
        computePassEncoder : ComputePassEncoder,
        groupLabel : cstring,
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

    DeviceCreateBuffer :: proc(
        device : Device,
        descriptor : ^BufferDescriptor,
    ) -> Buffer ---

    DeviceCreateCommandEncoder :: proc(
        device : Device,
        descriptor : ^CommandEncoderDescriptor,
    ) -> CommandEncoder ---

    DeviceCreateSampler :: proc(
        device : Device,
        descriptor : ^SamplerDescriptor,
    ) -> Sampler ---

    DeviceCreateShaderModule :: proc(
        device : Device,
        descriptor : ^ShaderModuleDescriptor,
    ) -> ShaderModule ---

    DeviceCreateSwapChain :: proc(
        device : Device,
        surface : Surface,
        descriptor : ^SwapChainDescriptor,
    ) -> SwapChain ---

    DeviceCreateTexture :: proc(
        device : Device,
        descriptor : ^TextureDescriptor,
    ) -> Texture ---

    DeviceDestroy :: proc(device : Device) ---

    DeviceGetLimits :: proc(
        device : Device,
        limits : ^SupportedLimits,
    ) -> bool ---

    DeviceGetQueue :: proc(device : Device) -> Queue ---

    DevicePopErrorScope :: proc(
        device : Device,
        callback : ErrorCallback,
        userdata : rawptr,
    ) -> bool ---

    DevicePushErrorScope :: proc(
        device : Device,
        filter : ErrorFilter,
    ) ---

    DeviceSetDeviceLostCallback :: proc(
        device : Device,
        callback : DeviceLostCallback,
        userdata : rawptr,
    ) ---

    DeviceSetUncapturedErrorCallback :: proc(
        device : Device,
        callback : ErrorCallback,
        userdata : rawptr,
    ) ---

    InstanceCreateSurface :: proc(
        instance : Instance,
        descriptor : ^SurfaceDescriptor,
    ) -> Surface ---

    InstanceProcessEvents :: proc(instance : Instance) ---

    InstanceRequestAdapter :: proc(
        instance : Instance,
        options : ^RequestAdapterOptions,
        callback : RequestAdapterCallback,
        userdata : rawptr,
    ) ---

    QuerySetDestroy :: proc(querySet : QuerySet) ---

    QueueOnSubmittedWorkDone :: proc(
        queue : Queue,
        signalValue : u64,
        callback : QueueWorkDoneCallback,
        userdata : rawptr,
    ) ---

    QueueWriteBuffer :: proc(
        queue : Queue,
        buffer : Buffer,
        bufferOffset : u64,
        data : rawptr,
        size : _c.size_t,
    ) ---

    QueueWriteTexture :: proc(
        queue : Queue,
        destination : ^ImageCopyTexture,
        data : rawptr,
        dataSize : _c.size_t,
        dataLayout : ^TextureDataLayout,
        writeSize : ^Extent3D,
    ) ---

    RenderBundleEncoderDraw :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        vertexCount : u32,
        instanceCount : u32,
        firstVertex : u32,
        firstInstance : u32,
    ) ---

    RenderBundleEncoderDrawIndexed :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        indexCount : u32,
        instanceCount : u32,
        firstIndex : u32,
        baseVertex : i32,
        firstInstance : u32,
    ) ---

    RenderBundleEncoderDrawIndexedIndirect :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        indirectBuffer : Buffer,
        indirectOffset : u64,
    ) ---

    RenderBundleEncoderDrawIndirect :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        indirectBuffer : Buffer,
        indirectOffset : u64,
    ) ---

    RenderBundleEncoderFinish :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        descriptor : ^RenderBundleDescriptor,
    ) -> RenderBundle ---

    RenderBundleEncoderInsertDebugMarker :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        markerLabel : cstring,
    ) ---

    RenderBundleEncoderPopDebugGroup :: proc(renderBundleEncoder : RenderBundleEncoder) ---

    RenderBundleEncoderPushDebugGroup :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        groupLabel : cstring,
    ) ---

    RenderBundleEncoderSetBindGroup :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        groupIndex : u32,
        group : BindGroup,
        dynamicOffsetCount : u32,
        dynamicOffsets : ^u32,
    ) ---

    RenderBundleEncoderSetIndexBuffer :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        buffer : Buffer,
        format : IndexFormat,
        offset : u64,
        size : u64,
    ) ---

    RenderBundleEncoderSetPipeline :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        pipeline : RenderPipeline,
    ) ---

    RenderBundleEncoderSetVertexBuffer :: proc(
        renderBundleEncoder : RenderBundleEncoder,
        slot : u32,
        buffer : Buffer,
        offset : u64,
        size : u64,
    ) ---

    RenderPassEncoderBeginOcclusionQuery :: proc(
        renderPassEncoder : RenderPassEncoder,
        queryIndex : u32,
    ) ---

    RenderPassEncoderBeginPipelineStatisticsQuery :: proc(
        renderPassEncoder : RenderPassEncoder,
        querySet : QuerySet,
        queryIndex : u32,
    ) ---

    RenderPassEncoderDraw :: proc(
        renderPassEncoder : RenderPassEncoder,
        vertexCount : u32,
        instanceCount : u32,
        firstVertex : u32,
        firstInstance : u32,
    ) ---

    RenderPassEncoderDrawIndexed :: proc(
        renderPassEncoder : RenderPassEncoder,
        indexCount : u32,
        instanceCount : u32,
        firstIndex : u32,
        baseVertex : i32,
        firstInstance : u32,
    ) ---

    RenderPassEncoderDrawIndexedIndirect :: proc(
        renderPassEncoder : RenderPassEncoder,
        indirectBuffer : Buffer,
        indirectOffset : u64,
    ) ---

    RenderPassEncoderDrawIndirect :: proc(
        renderPassEncoder : RenderPassEncoder,
        indirectBuffer : Buffer,
        indirectOffset : u64,
    ) ---

    RenderPassEncoderEndOcclusionQuery :: proc(renderPassEncoder : RenderPassEncoder) ---

    RenderPassEncoderEndPass :: proc(renderPassEncoder : RenderPassEncoder) ---

    RenderPassEncoderEndPipelineStatisticsQuery :: proc(renderPassEncoder : RenderPassEncoder) ---

    RenderPassEncoderExecuteBundles :: proc(
        renderPassEncoder : RenderPassEncoder,
        bundlesCount : u32,
        bundles : ^RenderBundle,
    ) ---

    RenderPassEncoderInsertDebugMarker :: proc(
        renderPassEncoder : RenderPassEncoder,
        markerLabel : cstring,
    ) ---

    RenderPassEncoderPopDebugGroup :: proc(renderPassEncoder : RenderPassEncoder) ---

    RenderPassEncoderPushDebugGroup :: proc(
        renderPassEncoder : RenderPassEncoder,
        groupLabel : cstring,
    ) ---

    RenderPassEncoderSetBindGroup :: proc(
        renderPassEncoder : RenderPassEncoder,
        groupIndex : u32,
        group : BindGroup,
        dynamicOffsetCount : u32,
        dynamicOffsets : ^u32,
    ) ---

    RenderPassEncoderSetBlendConstant :: proc(
        renderPassEncoder : RenderPassEncoder,
        color : ^Color,
    ) ---

    RenderPassEncoderSetIndexBuffer :: proc(
        renderPassEncoder : RenderPassEncoder,
        buffer : Buffer,
        format : IndexFormat,
        offset : u64,
        size : u64,
    ) ---

    RenderPassEncoderSetPipeline :: proc(
        renderPassEncoder : RenderPassEncoder,
        pipeline : RenderPipeline,
    ) ---

    RenderPassEncoderSetScissorRect :: proc(
        renderPassEncoder : RenderPassEncoder,
        x : u32,
        y : u32,
        width : u32,
        height : u32,
    ) ---

    RenderPassEncoderSetStencilReference :: proc(
        renderPassEncoder : RenderPassEncoder,
        reference : u32,
    ) ---

    RenderPassEncoderSetVertexBuffer :: proc(
        renderPassEncoder : RenderPassEncoder,
        slot : u32,
        buffer : Buffer,
        offset : u64,
        size : u64,
    ) ---

    RenderPassEncoderSetViewport :: proc(
        renderPassEncoder : RenderPassEncoder,
        x : _c.float,
        y : _c.float,
        width : _c.float,
        height : _c.float,
        minDepth : _c.float,
        maxDepth : _c.float,
    ) ---

    RenderPassEncoderWriteTimestamp :: proc(
        renderPassEncoder : RenderPassEncoder,
        querySet : QuerySet,
        queryIndex : u32,
    ) ---

    RenderPipelineGetBindGroupLayout :: proc(
        renderPipeline : RenderPipeline,
        groupIndex : u32,
    ) -> BindGroupLayout ---

    RenderPipelineSetLabel :: proc(
        renderPipeline : RenderPipeline,
        label : cstring,
    ) ---

    ShaderModuleSetLabel :: proc(
        shaderModule : ShaderModule,
        label : cstring,
    ) ---

    SurfaceGetPreferredFormat :: proc(
        surface : Surface,
        adapter : Adapter,
    ) -> TextureFormat ---

    SwapChainGetCurrentTextureView :: proc(swapChain : SwapChain) -> TextureView ---

    SwapChainPresent :: proc(swapChain : SwapChain) ---

    TextureCreateView :: proc(
        texture : Texture,
        descriptor : ^TextureViewDescriptor,
    ) -> TextureView ---

    TextureDestroy :: proc(texture : Texture) ---

}

@(default_calling_convention="c")
foreign lib {
    @(link_name="wgpuDeviceCreatePipelineLayout")
    DeviceCreatePipelineLayoutC :: proc(
        device : Device,
        descriptor : ^PipelineLayoutDescriptorC,
    ) -> PipelineLayout ---

    @(link_name="wgpuDeviceCreateQuerySet")
    DeviceCreateQuerySetC :: proc(
        device : Device,
        descriptor : ^QuerySetDescriptorC,
    ) -> QuerySet ---

    @(link_name="wgpuComputePassEncoderSetBindGroup")
    ComputePassEncoderSetBindGroupC :: proc(
        computePassEncoder : ComputePassEncoder,
        groupIndex : u32,
        group : BindGroup,
        dynamicOffsetCount : u32,
        dynamicOffsets : ^u32,
    ) ---
    
    @(link_name="wgpuQueueSubmit")
    QueueSubmitC :: proc(
        queue : Queue,
        commandCount : u32,
        commands : ^CommandBuffer,
    ) ---

    @(link_name="wgpuDeviceCreateRenderBundleEncoder")
    DeviceCreateRenderBundleEncoderC :: proc(
        device : Device,
        descriptor : ^RenderBundleEncoderDescriptorC,
    ) -> RenderBundleEncoder ---
    
    
    @(link_name="wgpuDeviceCreateComputePipeline")
    DeviceCreateComputePipelineC :: proc(
        device : Device,
        descriptor : ^ComputePipelineDescriptorC,
    ) -> ComputePipeline ---

    @(link_name="wgpuDeviceCreateComputePipelineAsync")
    DeviceCreateComputePipelineAsyncC :: proc(
        device : Device,
        descriptor : ^ComputePipelineDescriptorC,
        callback : CreateComputePipelineAsyncCallback,
        userdata : rawptr,
    ) ---

    @(link_name="wgpuDeviceCreateBindGroup")
    DeviceCreateBindGroupC :: proc(
        device : Device,
        descriptor : ^BindGroupDescriptorC,
    ) -> BindGroup ---
    
    @(link_name="wgpuDeviceCreateBindGroupLayout")
    DeviceCreateBindGroupLayoutC :: proc(
        device : Device,
        descriptor : ^BindGroupLayoutDescriptorC,
    ) -> BindGroupLayout ---
    
    @(link_name="wgpuDeviceCreateRenderPipeline")
    DeviceCreateRenderPipelineC :: proc(
        device : Device,
        descriptor : ^RenderPipelineDescriptorC,
    ) -> RenderPipeline ---

    @(link_name="wgpuDeviceCreateRenderPipelineAsync")
    DeviceCreateRenderPipelineAsyncC :: proc(
        device : Device,
        descriptor : ^RenderPipelineDescriptorC,
        callback : CreateRenderPipelineAsyncCallback,
        userdata : rawptr,
    ) ---
    
    @(link_name="wgpuAdapterRequestDevice")
    AdapterRequestDeviceC :: proc(
        adapter : Adapter,
        descriptor : ^DeviceDescriptorC,
        callback : RequestDeviceCallback,
        userdata : rawptr,
    ) ---

    @(link_name="wgpuCommandEncoderBeginRenderPass")
    CommandEncoderBeginRenderPassC :: proc(
        commandEncoder : CommandEncoder,
        descriptor : ^RenderPassDescriptorC,
    ) -> RenderPassEncoder ---

}
