extends StaticBody3D

@onready var ParentNode = $".."

func _ready() -> void:
	SignalManager.KeyStatus.connect(self.HandleKeyStatus)

func _input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:	
	if event is InputEventMouseButton and event.is_action_pressed("Interact"):
		SignalManager.KeyStatus.emit(true)

func HandleKeyStatus(pick: bool) -> void:
	if pick:
		ParentNode.hide()
	else:
		ParentNode.show()
