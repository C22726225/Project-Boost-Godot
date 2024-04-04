extends Control

func pause_menu() -> void:
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_button_pressed() -> void:
	get_tree().quit()
