struct OutVertex {
    [[builtin(position)]] pos: vec4<f32>;
    [[location(0)]] uv: vec2<f32>;
};

[[stage(vertex)]]
fn vs_main([[location(0)]] in_pos: vec2<f32>,
           [[location(1)]] in_uv: vec2<f32>
) -> OutVertex
{
    var out: OutVertex;
    out.pos = vec4<f32>(in_pos.x, in_pos.y, 0.0, 1.0);
    out.uv = vec2<f32>(in_uv.x, in_uv.y);
    return out;
}

[[group(0), binding(0)]] var texture: texture_2d<f32>;
[[group(0), binding(1)]] var texture_sampler: sampler;

[[stage(fragment)]]
fn fs_main([[location(0)]] in_uv: vec2<f32>) -> [[location(0)]] vec4<f32>
{
    return textureSample(texture, texture_sampler, in_uv);
}