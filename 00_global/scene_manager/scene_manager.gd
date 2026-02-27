extends CanvasLayer

signal load_scene_started
signal new_scene_ready(target_name: String, offset: Vector2)
signal load_scene_finished


func _ready() -> void:
	await get_tree().process_frame
	load_scene_finished.emit()


func transition_scene(new_scene: String, target_area: String, player_offset: Vector2, dir: String) -> void:
	load_scene_started.emit()

	# fade old scene out

	await get_tree().process_frame

	get_tree().change_scene_to_file(new_scene)

	await get_tree().scene_changed

	new_scene_ready.emit(target_area, player_offset)

	# wait 1 frame to take Player character moving into account
	# (still needs second frame of waiting in _on_load_scene_finished)
	await get_tree().physics_frame

	# fade new scene in

	load_scene_finished.emit()
