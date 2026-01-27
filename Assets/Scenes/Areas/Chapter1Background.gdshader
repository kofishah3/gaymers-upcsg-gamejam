shader_type canvas_item;

uniform vec4 base_tint : source_color = vec4(0.7, 0.7, 0.7, 1.0);
uniform float brightness : hint_range(0.0, 2.0) = 1.0;
uniform float contrast : hint_range(0.0, 2.0) = 1.1;
uniform sampler2D noise_img : repeat_enable; // Assign a NoiseTexture2D here
uniform float scratch_intensity : hint_range(0.0, 1.0) = 0.4;

void fragment() {
    // 1. Get the original tile color
    vec4 tex_color = texture(TEXTURE, UV);

    // 2. Use Screen UV or World Matrix for a seamless texture across all tiles
    // This prevents the "grid" look for the scratches
    vec2 world_uv = SCREEN_UV * 2.0;

    // 3. Sample the noise for scratches and grain
    vec4 noise_tex = texture(noise_img, world_uv);
    float noise_val = noise_tex.r;

    // 4. Create the "Highlight" (a static gradient representing a distant light)
    float highlight = smoothstep(0.2, 0.8, SCREEN_UV.y + SCREEN_UV.x * 0.5);

    // 5. Combine everything
    vec3 metal_base = tex_color.rgb * base_tint.rgb;

    // Add scratches by multiplying the noise
    vec3 scratched = mix(metal_base, metal_base * noise_val, scratch_intensity);

    // Add the static highlight sheen
    vec3 final_rgb = scratched + (highlight * 0.15);

    // Apply contrast and brightness
    final_rgb = ((final_rgb - 0.5) * contrast + 0.5) * brightness;

    COLOR = vec4(final_rgb, tex_color.a);
}