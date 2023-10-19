extends Node3D
class_name ObjectViewer

@onready var DescriptionLabel := %Label
@onready var ObjectViewport := %SubViewport
@onready var Canvas := $CanvasLayer

const ROTATION_INCREMENT := 0.03
const ZOOM_INCREMENT := 0.35

const MAX_ZOOM := 2.0
const MIN_ZOOM := -2.0

var object: Node3D
var attached_objects: Array[Node3D]

var description: String:
	get: return description
	set(value):
		description = value
		DescriptionLabel.text = description

var _instance: Node3D = null

func _input(event: InputEvent) -> void:
	if (is_instance_valid(_instance) and event is InputEventMouseButton):
		if event.is_action_pressed("zoom in") and _instance.position.z <= MAX_ZOOM:
			_instance.position.z += ZOOM_INCREMENT
		elif event.is_action_pressed("zoom out") and _instance.position.z >= MIN_ZOOM:
			_instance.position.z -= ZOOM_INCREMENT
		elif event.is_action_pressed("Cancel"):
			clear()

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
	_instance = Node3D.new()
	
	var object_instance = object.duplicate()
	object_instance.position = Vector3.ZERO
	_instance.add_child(object_instance)
	
	for attached_object in attached_objects:
		var attached_instance := attached_object.duplicate()
		attached_instance.position = attached_object.position - object.position
		_instance.add_child(attached_instance)
	
	ObjectViewport.add_child(_instance)
	SignalManager.CameraLock.emit(true)
	Canvas.show()
	
func clear():
	if _instance:
		_instance.queue_free()
		_instance = null
	SignalManager.CameraLock.emit(false)
	Canvas.hide()
	
