extends Camera3D

@onready var reticle = $CenterContainer/Reticle
@onready var reticle_clickable = $CenterContainer/ReticleClickable

var mouse = Vector2()

var cameraLocked := false

func _ready():
	SignalManager.connect("CameraLock", self.HandleCameraLock)

func HandleCameraLock(state):
	cameraLocked = state

func _input(event):
	if cameraLocked:
		return

	var selection = get_selection()
	update_cursor(selection)
	if event is InputEventMouse:
		mouse = event.position
	if event is InputEventMouseButton and event.is_action_pressed("Interact"):
		try_interact(selection)

func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	return result

func update_cursor(selection):
	if selection and selection.collider.has_method("player_interact"):
		reticle.hide()
		reticle_clickable.show()
	else:
		reticle.show()
		reticle_clickable.hide()

func try_interact(selection):
	if selection and selection.collider.has_method("player_interact"):
		selection.collider.player_interact()
