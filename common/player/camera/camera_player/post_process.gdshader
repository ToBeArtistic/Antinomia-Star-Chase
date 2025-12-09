shader_type spatial;

render_mode unshaded;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_nearest;

vec3 get_original(vec2 uv)
{
	return texture(SCREEN_TEXTURE, uv).rgb;
}

vec3 get_normal(vec2 uv)
{
	return texture(NORMAL_TEXTURE, uv).rgb * 2.0 - 1.0;	
}

float get_linear_depth(vec2 sUV, sampler2D depthTexture, mat4 invProjectionMat, float mask){
	// Raw depth to linear depth code from:
	// https://docs.godotengine.org/en/latest/tutorials/shaders/advanced_postprocessing.html
	float depth = texture(depthTexture, sUV).x * mask;
	vec3 ndc = vec3(sUV * 2.0 - 1.0, depth);
    vec4 view = invProjectionMat * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec3 original = get_original(SCREEN_UV);
	
	vec3 normal = get_normal(SCREEN_UV);
	
	float depth = get_linear_depth(SCREEN_UV, DEPTH_TEXTURE, INV_PROJECTION_MATRIX, 0.2);	
	ALBEDO = original;
}



//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
