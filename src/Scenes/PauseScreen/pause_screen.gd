extends Node2D

var is_paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		HandlePause(!is_paused)

func _on_resume_button_pressed() -> void:
	HandlePause(false)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func HandlePause(pause: bool) -> void:
	is_paused = pause

	if (is_paused):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$CanvasLayer.show()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$CanvasLayer.hide()

	get_tree().paused = is_paused
	
