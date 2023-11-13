extends StaticBody3D

var lockedVoice = preload("res://Assets/Voice/peter-heavy-door.mp3")

func can_interact() -> bool:
	return true;
	
func player_interact() -> void:
	%AudioStreamPlayer.set_stream(lockedVoice)
	%AudioStreamPlayer.play()
