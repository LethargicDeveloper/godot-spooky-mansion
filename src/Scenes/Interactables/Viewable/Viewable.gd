extends StaticBody3D

@onready var MainNode := $"../.."
@onready var MeshInstance := $".."
@onready var object_viewer := get_tree().get_root().get_node("Main/ObjectViewer")

func can_interact() -> bool:
	return true

func player_interact() -> void:
	SignalManager.CameraLock.connect(self.HandleCameraLock)
	object_viewer.object = MeshInstance
	object_viewer.description = "A box!"
	object_viewer.show_object()

func HandleCameraLock(state) -> void:
	if (state == false):
		SignalManager.CameraLock.disconnect(self.HandleCameraLock)
		cancel_viewable()
	
func cancel_viewable() -> void:
	object_viewer.clear()
