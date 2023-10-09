extends StaticBody3D

@onready var MainNode := $"../.."
@onready var MeshInstance := $".."

var ViewableClone: MeshInstance3D = null

const ROTATION_INCREMENT := 0.03
const ZOOM_INCREMENT := 0.5

func _ready() -> void:
	SignalManager.CameraLock.connect(self.HandleCameraLock)

func _input(event: InputEvent) -> void:
	if (is_instance_valid(ViewableClone) and event is InputEventMouseButton):
		if event.is_action_pressed("zoom in"):
			# Should move it closer to camera (some min distance)
			ViewableClone.position.z += ZOOM_INCREMENT
		elif event.is_action_pressed("zoom out"):
			# Should move it further from camera (some max distance)
			ViewableClone.position.z -= ZOOM_INCREMENT

func _physics_process(delta: float) -> void:
	if (is_instance_valid(ViewableClone)):
		if Input.is_action_pressed("forward"):
			ViewableClone.rotation.x += ROTATION_INCREMENT
		elif Input.is_action_pressed("backward"):
			ViewableClone.rotation.x -= ROTATION_INCREMENT

		if Input.is_action_pressed("left"):
			ViewableClone.rotation.y += ROTATION_INCREMENT
		elif Input.is_action_pressed("right"):
			ViewableClone.rotation.y -= ROTATION_INCREMENT

func can_interact() -> bool:
	return true

func player_interact() -> void:
	SignalManager.CameraLock.emit(true)
	enable_viewable()

func HandleCameraLock(state) ->	void:
	if (state == false):
		cancel_viewable()

func enable_viewable() -> void:
	if (!is_instance_valid(ViewableClone)):
		ViewableClone = MeshInstance.duplicate()
		# Position clone set distance in front of camera
		MainNode.add_child(ViewableClone)
	
func cancel_viewable() -> void:	
	if (is_instance_valid(ViewableClone)):
		ViewableClone.queue_free()
		ViewableClone = null
