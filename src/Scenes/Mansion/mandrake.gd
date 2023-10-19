extends StaticBody3D

@onready var object_viewer := get_tree().get_root().get_node("Main/ObjectViewer")

@export var attached_objects: Array[Node3D]

func can_interact() -> bool:
	return true

func player_interact() -> void:
	SignalManager.CameraLock.connect(self.HandleCameraLock)
	object_viewer.object = self.get_parent()
	object_viewer.attached_objects = attached_objects
	object_viewer.description = "I'm a mandrake!"
	object_viewer.show_object()

func HandleCameraLock(state) -> void:
	if (state == false):
		SignalManager.CameraLock.disconnect(self.HandleCameraLock)
		cancel_viewable()
	
func cancel_viewable() -> void:
	object_viewer.clear()
