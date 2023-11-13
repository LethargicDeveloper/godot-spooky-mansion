extends Node3D

var teleportSFX = preload("res://Assets/SFX/hallway-teleport.mp3")
var teleportVoice = preload("res://Assets/Voice/peter-hallway.mp3")

var looked_out_window := false

func _ready() -> void:
	SignalManager.LockScreen.emit(true)
	var stream = preload("res://Assets/Voice/peter-waking up.mp3")
	$AudioStreamPlayer.set_stream(stream)
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	SignalManager.LockScreen.emit(false)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !looked_out_window and body.name == "Player":
		looked_out_window = true
		var stream = preload("res://Assets/Voice/peter-spooky forest.mp3")
		$AudioStreamPlayer.set_stream(stream)
		$AudioStreamPlayer.play()


func _on_hallway_right_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		playSFX()
		$Player.transform = $TeleportLeft.transform

func _on_hallway_left_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		playSFX()
		$Player.transform = $TeleportRight.transform

func playSFX() -> void:
	$AudioStreamPlayer.set_stream(teleportSFX)
	$AudioStreamPlayer.play()

	await $AudioStreamPlayer.finished

	$AudioStreamPlayer.set_stream(teleportVoice)
	$AudioStreamPlayer.play()
