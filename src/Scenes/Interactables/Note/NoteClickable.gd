extends StaticBody3D

@onready var MainNode := $"../.."
@onready var TextPopup := $"../../TextPopup"

func _ready() -> void:
	TextPopup.visible = false
	
func _input(event: InputEvent) -> void:
	if TextPopup.visible and event and event.is_action_pressed("Cancel"):
		TextPopup.hide()
		SignalManager.CameraLock.emit(false)

func can_interact() -> bool:
	return true

func player_interact() -> void:
	if !TextPopup.visible:
		TextPopup.show()
		SignalManager.CameraLock.emit(true)
