extends StaticBody3D

@onready var MainNode = $"../.."
@onready var TextPopup = $"../../TextPopup"

func _input(event):
	if TextPopup.visible and event and event.is_action_pressed("Cancel"):
		TextPopup.hide()
		SignalManager.CameraLock.emit(false)

func player_interact():
	if !TextPopup.visible:
		TextPopup.show()
		SignalManager.CameraLock.emit(true)
