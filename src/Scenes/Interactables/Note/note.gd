extends Node3D

@export_multiline var Description: String
@export var Voice: AudioStream
@export var AudioPlayer: AudioStreamPlayer

func _ready() -> void:
	$Note/NoteStaticBody.Description = Description
	$Note/NoteStaticBody.Voice = Voice
	$Note/NoteStaticBody.AudioPlayer = AudioPlayer
