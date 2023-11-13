extends StaticBody3D

@onready var parent = $".."
@export var type: GlobalTypes.BookType

var base_position: Vector3
var isPushed = false

var pushSFX = preload("res://Assets/SFX/book-push.mp3")

func _ready() -> void:
	base_position = parent.position
	SignalManager.Puzzle1BookPush.connect(self.HandleBookPush)

func can_interact() -> bool:
	return !isPushed

func player_interact() -> void:
	if (!isPushed):
		SignalManager.Puzzle1BookPush.emit(type, true)

func HandleBookPush(bookType: GlobalTypes.BookType, pushed: bool):
	if (bookType == type):
		isPushed = pushed

		%AudioStreamPlayer.set_stream(pushSFX)
		%AudioStreamPlayer.play()

		var tween = create_tween()
		tween.parallel().tween_property(parent, "position", base_position + Vector3(0.1 if isPushed else 0.0, 0.0, 0.0), 0.25)
