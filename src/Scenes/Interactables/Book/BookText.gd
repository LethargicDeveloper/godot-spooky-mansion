extends Label

@onready var MainNode = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	var content = MainNode.get_meta("Content")
	if content:
		self.text = content
