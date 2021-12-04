struct OutVertex {
    [[builtin(position)]] pos: vec4<f32>;
    [[location(0)]] color: vec4<f32>;
};

[[stage(vertex)]]
fn vs_main([[location(0)]] in_pos: vec2<f32>,
           [[location(1)]] in_color: vec4<f32>
) -> OutVertex
{
    var out: OutVertex;
    out.pos = vec4<f32>(in_pos.x, in_pos.y, 0.0, 1.0);
    out.color = in_color;
    return out;
}

[[stage(fragment)]]
fn fs_main([[location(0)]] in_color: vec4<f32>) -> [[location(0)]] vec4<f32>
{
    return in_color;
}