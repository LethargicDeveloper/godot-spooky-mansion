extends Node3D
class_name ObjectViewer

@onready var DescriptionLabel := %Label
@onready var ObjectViewport := %SubViewport
@onready var Canvas := $CanvasLayer

const ROTATION_INCREMENT := 0.03
const ZOOM_INCREMENT := 0.5

var object: MeshInstance3D
var description: String:
	get: return description
	set(value):
		description = value
		DescriptionLabel.text = description

var _instance: MeshInstance3D = null

func _input(event: InputEvent) -> void:
	if (is_instance_valid(_instance) and event is InputEventMouseButton):
		if event.is_action_pressed("zoom in"):
			_instance.position.z += ZOOM_INCREMENT
		elif event.is_action_pressed("zoom out"):
			_instance.position.z -= ZOOM_INCREMENT

func _physics_process(_delta: float) -> void:
	if (is_instance_valid(_instance)):
		if Input.is_action_pressed("forward"):
			_instance.rotation.x += ROTATION_INCREMENT
		elif Input.is_action_pressed("backward"):
			_instance.rotation.x -= ROTATION_INCREMENT

		if Input.is_action_pressed("left"):
			_instance.rotation.y += ROTATION_INCREMENT
		elif Input.is_action_pressed("right"):
			_instance.rotation.y -= ROTATION_INCREMENT

func show_object():
	_instance = object.duplicate()
	ObjectViewport.add_child(_instance)
	SignalManager.CameraLock.emit(true)
	Canvas.show()
	
func clear():
	_instance.queue_free()
	Canvas.hide()
	
