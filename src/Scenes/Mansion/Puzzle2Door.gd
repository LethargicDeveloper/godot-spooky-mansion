extends StaticBody3D

@onready var parent = $".."

@export var DoorNode: Node3D

var OpenPositionVector = Vector3(-2.66, 0, 1)
var OpenRotationVector = Vector3(0, -152, 0)

var opened := false
var canOpen := false

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
		var stream = preload("res://Assets/Voice/peter-the door is locked.mp3")
		%AudioStreamPlayer.set_stream(stream)
		%AudioStreamPlayer.play()
	
func open_door() -> void:
	opened = true

	var tween = create_tween()
	tween.parallel().tween_property(parent, "position", parent.position + OpenPositionVector, 1)
	tween.parallel().tween_property(parent, "rotation_degrees", parent.rotation + OpenRotationVector, 1)
	
	tween.parallel().tween_property(DoorNode, "position", DoorNode.position + OpenPositionVector, 1)
	tween.parallel().tween_property(DoorNode, "rotation_degrees", parent.rotation + OpenRotationVector, 1)
