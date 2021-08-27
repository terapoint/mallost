shader_type canvas_item;

uniform vec4 REPLACEMENT_COLOR : hint_color;

void fragment() {
	vec4 current_color = texture(TEXTURE,UV);
	
	if (current_color.r > 0.92 && current_color.g > 0.92 && current_color.b > 0.92) {
		COLOR = REPLACEMENT_COLOR;
	} else {
		COLOR = current_color;
	}
}