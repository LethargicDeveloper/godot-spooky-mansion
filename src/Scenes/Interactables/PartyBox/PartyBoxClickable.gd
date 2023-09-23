extends StaticBody3D

@onready var PartyBox := $".."

var rng := RandomNumberGenerator.new()

func can_interact() -> bool:
	return true

func player_interact() -> void:
	var r = rng.randf_range(0, 1)
	var g = rng.randf_range(0, 1)
	var b = rng.randf_range(0, 1)
	var material = PartyBox.get_surface_override_material(0)
	material.albedo_color = Color(r, g, b)
	PartyBox.set_surface_override_material(0, material)
