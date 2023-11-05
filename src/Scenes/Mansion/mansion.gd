extends Node3D

@onready var Ceiling = $Ceiling
@onready var BloodAlter = $BloodAlter/StaticBody3D

var pipes: Array[Node]
var bloods: Dictionary

func _ready() -> void:
	Ceiling.visible = true
	pipes = get_tree().get_nodes_in_group("pipe")
	for pipe in pipes:
		pipe.rotate_pipe.connect(process_pipe_puzzle)
		var pipe_parent = pipe.get_parent().name
		bloods[pipe_parent] = false

func process_pipe_puzzle() -> void:
	if BloodAlter.activated:
		for i in 16:
			for pipe in pipes:
				var pipe_parent = pipe.get_parent().name
				var blood = get_node(pipe_parent + "_blood")

				if pipe_parent == "Pipe_1x2":
					bloods[pipe_parent] = true
					blood.show()

				if pipe_parent == "Pipe_1x3":
					if blood.rotation_degrees.y != 0:
						bloods[pipe_parent] = true
						blood.show()
					else:
						bloods[pipe_parent] = false
						blood.hide()

				if pipe_parent == "Pipe_2x2":
					if blood.rotation_degrees.y == 0 or blood.rotation_degrees.y == 180:
						bloods[pipe_parent] = true
						blood.show()
					else:
						bloods[pipe_parent] = false
						blood.hide()

				if pipe_parent == "Pipe_2x3":
					if blood.rotation_degrees.y == 90 or blood.rotation_degrees.y == 180 and bloods["Pipe_1x3"]:
						bloods[pipe_parent] = true
						blood.show()
					else:
						bloods[pipe_parent] = false
						blood.hide()

				if pipe_parent == "Pipe_2x4":
					if blood.rotation_degrees.y == 180 and bloods["Pipe_1x3"] and bloods["Pipe_2x3"]:
						bloods[pipe_parent] = true
						blood.show()
					else:
						bloods[pipe_parent] = false
						blood.hide()

				if pipe_parent == "Pipe_3x2":
					if blood.rotation_degrees.y == 180 and bloods["Pipe_2x2"]:
						bloods[pipe_parent] = true
						blood.show()
					else:
						bloods[pipe_parent] = false
						blood.hide()

				if pipe_parent == "Pipe_3x3":
					if (blood.rotation_degrees.y == 0 or blood.rotation_degrees.y == 180) and (bloods["Pipe_2x2"] and bloods["Pipe_3x2"]):
						bloods[pipe_parent] = true
						blood.show()
					else:
						bloods[pipe_parent] = false
						blood.hide()

				if pipe_parent == "Pipe_3x4":
					if ((blood.rotation_degrees.y == 0 or blood.rotation_degrees.y == 270) and (bloods["Pipe_2x2"] and bloods["Pipe_3x2"] and bloods["Pipe_3x3"])) or ((blood.rotation_degrees.y == 90 or blood.rotation_degrees.y == 270) and (bloods["Pipe_1x3"] and bloods["Pipe_2x3"] and bloods["Pipe_2x4"])):
						bloods[pipe_parent] = true
						blood.show()
					else:
						bloods[pipe_parent] = false
						blood.hide()

				if pipe_parent == "Pipe_4x4":
					if (blood.rotation_degrees.y == 90 or blood.rotation_degrees.y == 270) and ((bloods["Pipe_2x2"] and bloods["Pipe_3x2"] and bloods["Pipe_3x3"] and bloods["Pipe_3x4"]) or (bloods["Pipe_1x3"] and bloods["Pipe_2x3"] and bloods["Pipe_2x4"] and bloods["Pipe_3x4"])):
						bloods[pipe_parent] = true
						blood.show()
						
						if !SignalManager.puzzle3_complete:
							SignalManager.puzzle3_complete = true
							$AnimationPlayer.play("empty_blood")
							await $AnimationPlayer.animation_finished
					else:
						bloods[pipe_parent] = false
						blood.hide()
		
		if SignalManager.puzzle3_complete:
			for pipe in pipes:
				var pipe_parent = pipe.get_parent().name
				var blood = get_node(pipe_parent + "_blood")
				blood.hide()
