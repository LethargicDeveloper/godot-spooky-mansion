extends StaticBody3D

signal rotate_pipe

@onready var MeshInstance := $".."

var BloodMesh: MeshInstance3D

func _ready() -> void:
	BloodMesh = get_node("../../" + MeshInstance.name + "_blood")

var interacted := false

func _process(delta: float) -> void:
	if interacted:
		interacted = false
		MeshInstance.rotation_degrees.y += 90
		if MeshInstance.rotation_degrees.y >= 360:
			MeshInstance.rotation_degrees.y = 0
			
		BloodMesh.rotation_degrees.y = MeshInstance.rotation_degrees.y
		rotate_pipe.emit()

func can_interact() -> bool:
	return true

func player_interact() -> void:
	interacted = true
	
