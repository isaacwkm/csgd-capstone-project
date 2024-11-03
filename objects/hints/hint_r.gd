class_name HintR
extends Hint

@onready var _item := $'..' as Candle

func _should_open():
	return _item.is_carried()

func _should_close():
	return Input.is_action_pressed(&'break_candle')
