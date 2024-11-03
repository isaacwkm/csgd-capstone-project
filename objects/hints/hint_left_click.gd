class_name HintLeftClick
extends Hint

@onready var _player_character := $'../../PlayerCharacter' as PlayerCharacter

func _should_open():
	return (
		_player_character.current_animation == &'break_candle_left' or
		_player_character.current_animation == &'break_candle_right'
	)

func _should_close():
	return _player_character.in_wind_up_animation()
