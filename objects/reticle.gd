class_name Reticle
extends Sprite2D

@export var stick_sensitivity: float = 300.0
@export var stick_deadzone: float = 0.125

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		global_position = (
			(get_viewport_rect()*get_canvas_transform()).position +
			event.global_position
		)

func _process(delta: float):
	var input = Vector2(
		Input.get_axis(&'look_left', &'look_right'),
		Input.get_axis(&'look_up', &'look_down')
	)
	if input.length() > stick_deadzone:
		global_position += input*stick_sensitivity*delta
