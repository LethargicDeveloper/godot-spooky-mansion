extends Node3D

@export_multiline var BookContents: String

func _ready() -> void:
	$TextPopup/CenterBox/RichTextLabel.clear()
	$TextPopup/CenterBox/RichTextLabel.append_text("[center]" + BookContents + "[/center]")
