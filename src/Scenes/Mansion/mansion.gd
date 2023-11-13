extends Node3D

@export var Player: CharacterBody3D

@onready var Ceiling := $Ceiling
@onready var BloodAlter := $BloodAlter/StaticBody3D
@onready var SpookyBook := $bd2_Book/StaticBody3D
@onready var SpookySound1 := preload("res://Assets/Voice/devil-i am awoken.wav")
@onready var SpookySound2 := preload("res://Assets/Voice/peter-that was spooky.mp3")
@onready var KeyFound := preload("res://Assets/Voice/peter-found key.mp3")
@onready var doorSFX := preload("res://Assets/SFX/door-sliding.mp3")
@onready var inspected_spooky_book: bool = false
@onready var AudioPlayer := %AudioStreamPlayer
@onready var AnimPlayer := $AnimationPlayer

var game_over: bool = false
var ready_to_die: bool = false

var pipes: Array[Node]
var bloods: Dictionary

func _ready() -> void:
	SpookyBook.inspected.connect(on_spooky_book_inspected)
	SignalManager.KeyStatus.connect(on_key_collected)
	
	Ceiling.visible = true
	pipes = get_tree().get_nodes_in_group("pipe")
	for pipe in pipes:
		pipe.rotate_pipe.connect(process_pipe_puzzle)
		var pipe_parent = pipe.get_parent().name
		bloods[pipe_parent] = false

func on_key_collected(collected: bool) -> void:
	if collected:
		AudioPlayer.set_stream(KeyFound)
		AudioPlayer.play()

func on_spooky_book_inspected() -> void:
	if (!inspected_spooky_book):
		inspected_spooky_book = true
		await $AudioStreamPlayer.finished
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.set_stream(SpookySound1)
		player.play()
		await player.finished
		player.set_stream(SpookySound2)
		player.play()
		await player.finished
		player.queue_free()

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
							$AudioStreamPlayer.set_stream(doorSFX)
							$AudioStreamPlayer.play()
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


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player" and not game_over:
		$AnimationPlayer/Timer.stop()
		game_over = true
		AnimPlayer.play("game_over")
		await AnimPlayer.animation_finished
		ready_to_die = true
		
func pickup_cup() -> void:
	var chalice = $Chalice
	var blood = $Chalice_Blood
	var diff = blood.position - chalice.position
	
	chalice.reparent($Brother/Marker3D)
	chalice.position = Vector3.ZERO
	
	blood.reparent(chalice)
	blood.position = diff

func _on_ready_to_die_body_entered(body: Node3D) -> void:
	if body.name == "Player" and ready_to_die:
		SignalManager.GameOver.emit()

func _on_timer_timeout() -> void:
	var stream = load("res://Assets/Voice/mason-hurry up.mp3")
	$AudioStreamPlayer2.set_stream(stream)
	$AudioStreamPlayer2.play()
