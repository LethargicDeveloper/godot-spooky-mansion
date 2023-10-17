extends StaticBody3D

@onready var MainNode := $"../.."
@onready var MeshInstance := $".."
@onready var object_viewer := get_tree().get_root().get_node("Main/ObjectViewer")

func _ready() -> void:
	SignalManager.CameraLock.connect(self.HandleCameraLock)

func can_interact() -> bool:
	return true

func player_interact() -> void:
	object_viewer.object = MeshInstance
	object_viewer.description = "A box!"
	object_viewer.show_object()

func HandleCameraLock(state) ->	void:
	if (state == false):
		cancel_viewable()
	
func cancel_viewable() -> void:	
	object_viewer.clear()
