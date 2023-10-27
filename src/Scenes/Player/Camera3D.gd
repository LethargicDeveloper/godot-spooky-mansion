extends Camera3D

@onready var reticle := $CenterContainer/Reticle
@onready var reticle_clickable := $CenterContainer/ReticleClickable
@onready var dark_screen := $DarkScreen
@onready var KeyIcon := $HBoxContainer/KeyIcon

var mouse := Vector2()
var cameraLocked := false
var hasKey := false

func _ready():
	SignalManager.CameraLock.connect(self.HandleCameraLock)
	SignalManager.KeyStatus.connect(self.HandleKeyStatus)

func HandleCameraLock(state):
	cameraLocked = state
	if (state == true):
		dark_screen.show()
	else:
		dark_screen.hide()

func HandleKeyStatus(state) -> void:
	hasKey = state
	if state:
		KeyIcon.show()
	else:
		KeyIcon.hide()
		
func _input(event):
	if cameraLocked:
		return

	var selection := get_selection()
	update_cursor(selection)
	if event is InputEventMouse:
		mouse = event.position
	if event is InputEventMouseButton and event.is_action_pressed("Interact"):
		try_interact(selection)

func get_selection() -> Dictionary:
	var worldspace := get_world_3d().direct_space_state
	var start := project_ray_origin(mouse)
	var end := project_position(mouse, 1000)
	var result := worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	return result

func update_cursor(selection: Dictionary) -> void:
	if selection and selection.collider.has_method("can_interact") and selection.collider.can_interact():
		reticle.hide()
		reticle_clickable.show()
	else:
		reticle.show()
		reticle_clickable.hide()

func try_interact(selection: Dictionary) -> void:
	if selection and selection.collider.has_method("can_interact") and selection.collider.can_interact():
		selection.collider.player_interact()
