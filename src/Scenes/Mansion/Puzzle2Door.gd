extends StaticBody3D

@onready var parent = $".."

@export var DoorNode: Node3D

var OpenPositionVector = Vector3(-2.66, 0, 1)
var OpenRotationVector = Vector3(0, -152, 0)

var opened := false
var canOpen := false

var lockedVoice = preload("res://Assets/Voice/peter-the door is locked.mp3")
var lockedSFX = preload("res://Assets/SFX/door-locked.mp3")
var unlockSFX = preload("res://Assets/SFX/door-unlock.mp3")
var openSFX = preload("res://Assets/SFX/door-open.mp3")

func _ready():
	SignalManager.KeyStatus.connect(self.HandleKeyStatus)

func HandleKeyStatus(state) -> void:
	canOpen = state

func can_interact() -> bool:
	return true

func player_interact() -> void:
	if (canOpen and !opened):
		open_door()
	else:
		%AudioStreamPlayer.set_stream(lockedSFX)
		%AudioStreamPlayer.play()

		await %AudioStreamPlayer.finished

		%AudioStreamPlayer.set_stream(lockedVoice)
		%AudioStreamPlayer.play()
	
func open_door() -> void:
	SignalManager.KeyStatus.emit(false)
	opened = true

	%AudioStreamPlayer.set_stream(unlockSFX)
	%AudioStreamPlayer.play()

	await %AudioStreamPlayer.finished

	%AudioStreamPlayer.set_stream(openSFX)
	%AudioStreamPlayer.play()
	
	var tween = create_tween()
	tween.parallel().tween_property(parent, "position", parent.position + OpenPositionVector, 2.5)
	tween.parallel().tween_property(parent, "rotation_degrees", parent.rotation + OpenRotationVector, 2.5)
	
	tween.parallel().tween_property(DoorNode, "position", DoorNode.position + OpenPositionVector, 2.5)
	tween.parallel().tween_property(DoorNode, "rotation_degrees", parent.rotation + OpenRotationVector, 2.5)
