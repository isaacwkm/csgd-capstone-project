class_name Candle
extends CarriableItem

@onready var _collision_light = $CollisionEnablingLight
@onready var _sprite = $AnimatedSprite2D

var _hide_timer: float = -1.0

# Initialize the candle with specific properties
func initialize(scale_factor: float) -> void:
	if _collision_light:
		_collision_light.scale *= scale_factor

func _get_scale() -> Vector2:
	return _collision_light.scale

func _set_scale(_new_scale: Vector2):
	if _collision_light:
		_collision_light.scale = _new_scale

func hide_for_break_animation(duration: float):
	_hide_timer = duration
	_sprite.visible = false

func _process(delta: float):
	if _hide_timer > 0:
		_hide_timer -= delta
	if _hide_timer <= 0: # Intentionally if, not elif
		_sprite.visible = true
