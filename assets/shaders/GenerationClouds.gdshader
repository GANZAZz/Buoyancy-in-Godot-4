shader_type spatial;

render_mode depth_prepass_alpha, depth_draw_opaque, unshaded;

uniform sampler2D noiseTexture;
uniform bool isSoft = false;
uniform float speed : hint_range(0.0, 1.0) = 0.1;
uniform float brightness: hint_range(0.0, 2.0) = 0.1;
uniform float threshold : hint_range(0.0, 2.0) = 0.1;
uniform float fluffiness : hint_range(0.0, 2.0) = 0.1;


void fragment() {
	// Mixing two time-shifted textures to create fluffiness
	vec4 noise1 = texture(noiseTexture, mod(UV + TIME * 2.5 * speed / 10.0, 0.0));
	vec4 noise2 = texture(noiseTexture, mod(UV + TIME * (2.5 + fluffiness * 3.0) * speed / 10.0, 0.0));
	vec4 combinedNoise = noise1 + noise2;
	
	if (isSoft == true) {
		// Creating smooth transitions using smoothstep
		combinedNoise.a = combinedNoise.r;
		ALBEDO = smoothstep(threshold - 0.3, threshold + 0.3, combinedNoise).rgb * brightness;
		ALPHA =  smoothstep(threshold - 0.3, threshold + 0.3, combinedNoise).a;
	}
	else {
		// Creating hard transitions
		ALBEDO = combinedNoise.rgb * brightness;
		if (combinedNoise.r < threshold) {
			ALPHA = 0.0;
		}
		else {
			ALPHA = 1.0;
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
