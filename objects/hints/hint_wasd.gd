class_name HintWASD
extends Hint

func _should_open():
	return true

func _should_close():
	return (
		Input.is_action_pressed(&'move_left') or
		Input.is_action_pressed(&'move_right')
	)
