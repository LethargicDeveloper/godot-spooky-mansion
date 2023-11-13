extends CharacterBody3D

const SPEED := 5.0
const RUN_SPEED := 2.5
const JUMP_VELOCITY := 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var head := $Head
@onready var camera := $Head/Camera3D

var walkingStream: AudioStreamPlayer
var walkingSFX := preload("res://Assets/SFX/walking.mp3")

var cameraLocked := false

func _ready() -> void:
	SignalManager.CameraLock.connect(self.HandleCameraLock)
	SignalManager.LockScreen.connect(self.HandleLockScreen)
	walkingStream = AudioStreamPlayer.new()
	walkingStream.set_stream(walkingSFX)
	add_child(walkingStream)

func HandleLockScreen(lock: bool) -> void:
	set_process_input(!lock)
	set_physics_process(!lock)
	walkingStream.stop()

	if (!lock):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func HandleCameraLock(state: bool):
	cameraLocked = state
	walkingStream.stop()

	if (state):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if cameraLocked:
		if event.is_action_pressed("Escape"):
			SignalManager.CameraLock.emit(false)
	else:
		if event is InputEventMouseButton:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.is_action_pressed("Escape"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				head.rotate_y(-event.relative.x * 0.01)
				camera.rotate_x(-event.relative.y * 0.01)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if cameraLocked:
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var running := Input.is_key_pressed(KEY_SHIFT)
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var run_speed = RUN_SPEED if running else 1 
	
	if direction:
		velocity.x = direction.x * SPEED * run_speed
		velocity.z = direction.z * SPEED * run_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * run_speed)
		velocity.z = move_toward(velocity.z, 0, SPEED * run_speed)

	# SFX
	if (velocity.x != 0 || velocity.z != 0) and !walkingStream.playing:
		walkingStream.play()
	elif velocity.is_zero_approx() and walkingStream.playing:
		walkingStream.stop()	

	walkingStream.set_pitch_scale(2.0 if running else 1.0)

	move_and_slide()
