extends Control

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4, Color.DIM_GRAY)
	draw_circle(Vector2.ZERO, 3, Color.WHITE)
	
	draw_rect(Rect2(Vector2(17.0, 0.0), Vector2(6, 0.0)),Color.DIM_GRAY, false, 3.5)
	draw_rect(Rect2(Vector2(-17.0, 0.0), Vector2(-6, 0.0)),Color.DIM_GRAY, false, 3.5)
	draw_rect(Rect2(Vector2(0.0, 17), Vector2(0.0, 6 )),Color.DIM_GRAY, false, 3.5)
	draw_rect(Rect2(Vector2(0.0, -17), Vector2(0.0, -6)),Color.DIM_GRAY, false, 3.5)
	
	draw_line(Vector2(16, 0), Vector2(24, 0), Color.WHITE, 2)
	draw_line(Vector2(-16, 0), Vector2(-24, 0), Color.WHITE, 2)
	draw_line(Vector2(0, 16), Vector2(0, 24), Color.WHITE, 2)
	draw_line(Vector2(0, -16), Vector2(0, -24), Color.WHITE, 2)
