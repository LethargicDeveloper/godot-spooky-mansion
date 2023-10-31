extends Node3D

@onready var Ceiling = $Ceiling

func _ready() -> void:
	Ceiling.visible = true
