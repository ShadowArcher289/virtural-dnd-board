shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec2 circle_center = vec2(0.5, 0.3); // UV center of circle
uniform float circle_radius = 0.3;           // radius in UV space

void fragment() {
	vec4 tex = texture(albedo_texture, UV);

    // Distance from UV to circle center
    float dist = distance(UV, circle_center);

    // Mask: 1.0 inside circle, 0.0 outside
    float mask = step(dist, circle_radius);

    // Apply mask to alpha
    ALBEDO = tex.rgb;
    ALPHA = tex.a * mask;

    // Enable transparency
    if (ALPHA < 0.01) {
        discard;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
