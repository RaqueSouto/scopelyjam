shader_type canvas_item;

uniform float circle_radius : hint_range(0.0, 1.05) = 1.05f;
uniform vec2 screen_size;

void fragment() {
	float screen_ratio = screen_size.x / screen_size.y;
	float dist = distance(vec2(0.5, 0.5), vec2(mix(0.5, UV.x, screen_ratio), UV.y));
	COLOR.a = step(circle_radius, dist);
}
