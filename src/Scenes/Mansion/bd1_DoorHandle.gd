extends StaticBody3D

@export var locked: bool = true:
	get: return locked
	set(value): 
		locked = value
		if (not locked):
			open_door()

func can_interact() -> bool:
	return true

func player_interact() -> void:
	locked = false
	
func open_door() -> void:
	$"../../bd1_Door".queue_free()
	$"..".queue_free()
