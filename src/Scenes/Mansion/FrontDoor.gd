extends StaticBody3D

var lockedVoice = preload("res://Assets/Voice/peter-heavy-door.mp3")
var unlockSFX = preload("res://Assets/SFX/door-unlock.mp3")
var unlockVoice = preload("res://Assets/Voice/peter-guess-open.mp3")
var waitVoice = preload("res://Assets/Voice/mason-wait-going.mp3")

var can_leave := false

func _ready() -> void:
	SignalManager.BigDoorOpen.connect(HandleDoorOpen)

func can_interact() -> bool:
	return true;
	
func player_interact() -> void:
	if (can_leave):
		SignalManager.LockScreen.emit(true)

		%AudioStreamPlayer.set_stream(unlockSFX)
		%AudioStreamPlayer.play()
		await %AudioStreamPlayer.finished

		%AudioStreamPlayer.set_stream(unlockVoice)
		%AudioStreamPlayer.play()
		await %AudioStreamPlayer.finished
		
		%AudioStreamPlayer.set_stream(waitVoice)
		%AudioStreamPlayer.play()
		await %AudioStreamPlayer.finished

		SceneTransition.transition_to("res://Scenes/Credits/credits.tscn")		
	else:
		%AudioStreamPlayer.set_stream(lockedVoice)
		%AudioStreamPlayer.play()

func HandleDoorOpen() -> void:
	can_leave = true
