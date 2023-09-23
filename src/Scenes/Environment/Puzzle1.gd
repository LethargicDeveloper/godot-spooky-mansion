extends MeshInstance3D

const BookType = preload("res://Scenes/Global/BookType.gd").BookType

@export var Books: Node3D
@export var GoldBook: Node3D
@export var GreenBook: Node3D
@export var PurpleBook: Node3D
@export var MagentaBook: Node3D
@export var RedBook: Node3D

var PuzzleAttempt: Array[BookType] = []

const PuzzleSolution: Array[BookType] = [
	BookType.GREEN,	
	BookType.MAGENTA,
	BookType.RED,
	BookType.PURPLE,
	BookType.GOLD,
]

func _ready() -> void:
	SignalManager.Puzzle1BookPush.connect(self.HandleBookPush)

func HandleBookPush(type: BookType, pushed: bool):
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
	self.position.z += 2
	Books.position.z += 2
	GoldBook.position.z += 2
	GreenBook.position.z += 2
	PurpleBook.position.z += 2
	MagentaBook.position.z += 2
	RedBook.position.z += 2

func ResetBooks() -> void:
	await get_tree().create_timer(1).timeout
	SignalManager.Puzzle1BookPush.emit(BookType.GOLD, false)
	SignalManager.Puzzle1BookPush.emit(BookType.GREEN, false)
	SignalManager.Puzzle1BookPush.emit(BookType.PURPLE, false)
	SignalManager.Puzzle1BookPush.emit(BookType.MAGENTA, false)
	SignalManager.Puzzle1BookPush.emit(BookType.RED, false)
	PuzzleAttempt.clear()
