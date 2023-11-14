extends Node2D

func _on_timer_timeout() -> void:
	$AnimationPlayer.play("credits")
	$Timer2.start()

func _on_timer_2_timeout() -> void:
	SceneTransition.transition_to("res://Scenes/TitleScreen/title_screen.tscn")
