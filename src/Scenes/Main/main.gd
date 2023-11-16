extends Node3D

var teleportSFX = preload("res://Assets/SFX/hallway-teleport.mp3")
var teleportVoice = preload("res://Assets/Voice/peter-hallway.mp3")

var has_teleported := false
var looked_out_window := false

func _ready() -> void:
	SignalManager.GameOver.connect(game_over)

	SignalManager.LockScreen.emit(true)
	var stream = preload("res://Assets/Voice/peter-waking up.mp3")
	$AudioStreamPlayer.set_stream(stream)
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	SignalManager.LockScreen.emit(false)

func game_over() -> void:
	SignalManager.LockScreen.emit(true)
	
	var place_to_die = Vector3($PlaceToDie.position.x, 1.514, $PlaceToDie.position.z)
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($Player, "position", place_to_die, 1)
	tween.play()
	await tween.finished
	
	tween = create_tween()
	tween.parallel().tween_property($Player, "position:z", place_to_die.z + 1, 1)
	tween.parallel().tween_property($Player, "position:y", place_to_die.y - 1, 1)
	tween.parallel().tween_property($Player/Head/Camera3D, "position:z", $Player/Head/Camera3D.position.z + 1, 1)
	tween.parallel().tween_property($Player/Head/Camera3D, "position:y", $Player/Head/Camera3D.position.y - 1, 1)
	tween.play()
	await tween.finished
	
	$AnimationPlayer.play("sacrifice")
	await $AnimationPlayer.animation_finished
	SceneTransition.transition_to("res://Scenes/Credits/credits.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if !looked_out_window and body.name == "Player":
		looked_out_window = true
		var stream = preload("res://Assets/Voice/peter-spooky forest.mp3")
		$AudioStreamPlayer.set_stream(stream)
		$AudioStreamPlayer.play()

func _on_hallway_right_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		playSFX()

		$Player.transform = $TeleportLeft.transform

func _on_hallway_left_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		playSFX()

		$Player.transform = $TeleportRight.transform

func playSFX() -> void:
	$AudioStreamPlayer.set_stream(teleportSFX)
	$AudioStreamPlayer.play()

	if not has_teleported:
		has_teleported = true

		await $AudioStreamPlayer.finished
		
		$AudioStreamPlayer.set_stream(teleportVoice)
		$AudioStreamPlayer.play()

func start_stabbin() -> void:
	var brother := $Mansion/Brother
	
	var angle := 60
	
	var start_y = brother.rotation_degrees
	var end_y = brother.rotation_degrees + Vector3(0, angle, 0)
	
	var tween = create_tween().set_loops()
	tween.tween_property(brother, "rotation_degrees", end_y, 0.25).from(start_y)
	tween.tween_property(brother, "rotation_degrees", start_y, 0.25).from(end_y)
	tween.play()
