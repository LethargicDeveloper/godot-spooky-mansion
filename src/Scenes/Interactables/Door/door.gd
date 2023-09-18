extends StaticBody3D

@onready var Door := $"../.."

func player_interact() -> void:
	Door.queue_free()
