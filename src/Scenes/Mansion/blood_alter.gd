extends StaticBody3D

@onready var parent := $".."
@onready var BloodPool := $"../../BloodAlter_Blood"
@onready var player := $"../../AnimationPlayer"

var activated = false

func can_interact() -> bool:
	return !activated

func player_interact() -> void:
	if (!activated):
		SignalManager.LockScreen.emit(true)
		player.play("fill_blood")
		await player.animation_finished
		SignalManager.LockScreen.emit(false)
		activated = true
		$"../..".process_pipe_puzzle()
