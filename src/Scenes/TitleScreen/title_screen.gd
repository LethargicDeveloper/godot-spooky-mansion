extends Node2D

func _on_start_game_button_pressed() -> void:
	SceneTransition.transition_to("res://Scenes/Main/main.tscn")

func _on_quick_button_pressed() -> void:
	get_tree().quit()
