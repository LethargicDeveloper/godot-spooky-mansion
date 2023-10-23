extends Node3D

@export_multiline var Description: String

func _ready() -> void:
	$Note/NoteStaticBody.Description = Description
