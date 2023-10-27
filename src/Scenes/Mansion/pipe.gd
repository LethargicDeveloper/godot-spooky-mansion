extends StaticBody3D

@onready var MeshInstance := $".."

var interacted := false

func _process(delta: float) -> void:
	if interacted:
		interacted = false
		MeshInstance.rotation_degrees.y += 90
		if MeshInstance.rotation_degrees.y >= 360:
			MeshInstance.rotation_degrees.y = 0

func can_interact() -> bool:
	return true

func player_interact() -> void:
	interacted = true
	
