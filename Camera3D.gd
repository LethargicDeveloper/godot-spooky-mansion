extends Camera3D

@onready var box := $"../../../PartyBox"
@onready var box_collider := $"../../../PartyBox/StaticBody3D"

var mouse = Vector2()

var rng = RandomNumberGenerator.new()

func _input(event):
	if event is InputEventMouse:
		mouse = event.position
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_selection()

func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start = project_ray_origin(mouse)
	var end = project_position(mouse, 1000)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	if result and result.collider == box_collider:
		randomBoxColor()

func randomBoxColor():
	var r = rng.randf_range(0, 1)
	var g = rng.randf_range(0, 1)
	var b = rng.randf_range(0, 1)
	var material = box.get_surface_override_material(0)
	material.albedo_color = Color(r, g, b)
	box.set_surface_override_material(0, material)
