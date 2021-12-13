package wgpu

DevicePoll :: proc(
        device : Device,
        force_wait : bool,
) {
    DevicePollC(device, force_wait)
    if force_wait {
        free_all(context.temp_allocator)
    }
}