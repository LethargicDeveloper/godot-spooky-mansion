extends Node2D

func transition_to(path: String) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var scene = load(path)
	
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_packed(scene)
	
	$AnimationPlayer.play_backwards("fade")
	await $AnimationPlayer.animation_finished
