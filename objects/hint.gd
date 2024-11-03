class_name Hint
extends Sprite2D

enum State {
	NotYetOpen,
	Opening,
	Open,
	Closing
}

var _state := State.NotYetOpen

func _ready():
	visible = false
	modulate.a = 0.0

func _should_open() -> bool:
	# abstract
	return false

func _should_close() -> bool:
	# abstract
	return false

func _process(delta: float):
	if _state == State.NotYetOpen:
		if _should_open():
			visible = true
			_state = State.Opening
	elif _state == State.Opening:
		modulate.a = move_toward(modulate.a, 1.0, delta)
		if modulate.a >= 0.99:
			modulate.a = 1.0
			_state = State.Open
	elif _state == State.Open:
		if _should_close():
			_state = State.Closing
	elif _state == State.Closing:
		modulate.a = move_toward(modulate.a, 0.0, delta)
		if modulate.a <= 0.01:
			visible = false
			queue_free()
