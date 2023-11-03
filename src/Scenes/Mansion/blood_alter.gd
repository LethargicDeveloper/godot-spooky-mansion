extends StaticBody3D

@onready var parent = $".."
@onready var BloodPool = $"../../BloodAlter_Blood"
@onready var player = $"../../AnimationPlayer"

var activated = false

func can_interact() -> bool:
	return !activated

func player_interact() -> void:
	if (!activated):
		activated = true
		player.play("fill_blood")
		$"../..".process_pipe_puzzle()
		await player.animation_finished
