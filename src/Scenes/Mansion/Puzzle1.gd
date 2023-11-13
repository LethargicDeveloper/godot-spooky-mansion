extends MeshInstance3D

@export var Books: Array[Node3D]

var PuzzleAttempt: Array[GlobalTypes.BookType] = []

const PuzzleSolution: Array[GlobalTypes.BookType] = [
	GlobalTypes.BookType.GREEN,	
	GlobalTypes.BookType.MAGENTA,
	GlobalTypes.BookType.RED,
	GlobalTypes.BookType.PURPLE,
	GlobalTypes.BookType.GOLD,
]

var resetSFX = preload("res://Assets/SFX/book-reset.mp3")
var doorSlideSFX = preload("res://Assets/SFX/door-sliding.mp3")

func _ready() -> void:
	SignalManager.Puzzle1BookPush.connect(self.HandleBookPush)

func HandleBookPush(type: GlobalTypes.BookType, pushed: bool):
	if (pushed):
		PuzzleAttempt.append(type)
		if PuzzleAttempt.size() >= 5:
			if (CheckAttempt()):
				PuzzleComplete()
			else:
				ResetBooks()

func CheckAttempt():
	return PuzzleAttempt == PuzzleSolution

func PuzzleComplete() -> void:
	await get_tree().create_timer(1).timeout
	
	%AudioStreamPlayer.set_stream(doorSlideSFX)
	%AudioStreamPlayer.play()

	var tween = create_tween()
	tween.parallel().tween_property(self, "position", self.position + Vector3(0, 0, 3), 1)
	
	for book in Books:
		tween.parallel().tween_property(book, "position", book.position + Vector3(0, 0, 3), 1)

func ResetBooks() -> void:
	await get_tree().create_timer(1).timeout
	
	for book_type in GlobalTypes.BookType.keys():
		SignalManager.Puzzle1BookPush.emit(GlobalTypes.BookType[book_type], false)
	
	%AudioStreamPlayer.set_stream(resetSFX)
	%AudioStreamPlayer.play()

	PuzzleAttempt.clear()
