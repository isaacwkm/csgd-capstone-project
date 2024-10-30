shader_type canvas_item;
render_mode light_only;

const float sqrt_3 = sqrt(3.0);

void light() {
	LIGHT = vec4(
		COLOR.rgb*LIGHT_COLOR.rgb*LIGHT_ENERGY,
		COLOR.a*length(LIGHT_COLOR.rgb)*LIGHT_COLOR.a/sqrt_3
	);
}