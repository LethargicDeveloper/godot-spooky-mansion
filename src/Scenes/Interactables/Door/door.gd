extends StaticBody3D

@export var Door: Node3D
@export var DoorHandle: Node3D

func can_interact() -> bool:
	return true

func player_interact() -> void:
	Door.queue_free()
	DoorHandle.queue_free()
