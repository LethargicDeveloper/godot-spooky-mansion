extends StaticBody3D

@onready var PartyBox = $".."

var rng = RandomNumberGenerator.new()

func player_interact():
	var r = rng.randf_range(0, 1)
	var g = rng.randf_range(0, 1)
	var b = rng.randf_range(0, 1)
	var material = PartyBox.get_surface_override_material(0)
	material.albedo_color = Color(r, g, b)
	PartyBox.set_surface_override_material(0, material)
