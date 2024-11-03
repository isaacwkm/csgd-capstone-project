class_name Level
extends Node2D

func _unhandled_input(event: InputEvent):
	if event.is_action_released(&'restart_level'):
		get_tree().change_scene_to_file(scene_file_path)
