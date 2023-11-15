extends StaticBody3D

@export_multiline var Description: String
@export var PositionOverride := Vector3.ZERO
@export var RotationOverride := Vector3.ZERO
@export var Voice: AudioStream
@export var AudioPlayer: AudioStreamPlayer

@onready var MeshInstance := $".."
@onready var object_viewer := get_tree().get_root().get_node("MainWrapper/Main/ObjectViewer")

@export var attached_objects: Array[Node3D]

signal inspected

func can_interact() -> bool:
	return true

func player_interact() -> void:
	SignalManager.CameraLock.connect(self.HandleCameraLock)
	object_viewer.object = MeshInstance
	object_viewer.attached_objects = attached_objects
	object_viewer.initial_position = PositionOverride
	object_viewer.initial_rotation = RotationOverride
	object_viewer.description = Description
	object_viewer.show_object()
	if Voice and AudioPlayer:
		AudioPlayer.set_stream(Voice)
		AudioPlayer.play()
	inspected.emit()

func HandleCameraLock(state) -> void:
	if (state == false):
		SignalManager.CameraLock.disconnect(self.HandleCameraLock)
		cancel_viewable()
	
func cancel_viewable() -> void:
	if AudioPlayer and AudioPlayer.stream == Voice:
		AudioPlayer.stop()
	object_viewer.clear()
