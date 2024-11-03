class_name PlayerCharacter
extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

# Preload the candle scene
@export var candle_scene: PackedScene = preload("res://objects/candle.tscn")
@export var candle_init_scale: float = 1.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0  # Define gravity here

const NON_MOVING_ANIMATION_DURATIONS := {
	&'break_candle_left': 0.25,
	&'break_candle_right': 0.25,
	&'throw_left': 0.5,
	&'throw_right': 0.5,
	&'wind_up_left': INF,
	&'wind_up_right': INF
}

var hasOwnCandle = false
var current_animation = ""  # Track the current animation
var facingRight = true
var heldItem: CarriableItem = null
var non_moving_animation_timer: float = INF

func _physics_process(delta):
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and not (
		in_non_moving_animation()
	):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement
	var direction = 0
	if Input.is_action_pressed("move_left") and not in_non_moving_animation():
		direction -= 1
		facingRight = false
		update_animation(
			"walk_left" if hasOwnCandle
			else "walk_left_no_candle"
		)
	elif Input.is_action_pressed("move_right") and not (
		in_non_moving_animation()
	):
		direction += 1
		facingRight = true
		update_animation(
			"walk_right" if hasOwnCandle
			else "walk_right_no_candle"
		)

	# Set velocity based on direction
	velocity.x = direction * SPEED
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Add gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump/fall animations if in the air
	if not is_on_floor() and not in_non_moving_animation():
		if facingRight:  # Moving right
			if velocity.y < 0:  # Ascending
				update_animation(
					"jump_right" if hasOwnCandle
					else "jump_right_no_candle"
				)
			elif velocity.y > 0:  # Descending
				update_animation(
					"fall_right" if hasOwnCandle
					else "fall_right_no_candle"
				)
		else:  # Moving left
			if velocity.y < 0:  # Ascending
				update_animation(
					"jump_left" if hasOwnCandle
					else "jump_left_no_candle"
				)
			elif velocity.y > 0:  # Descending
				update_animation(
					"fall_left" if hasOwnCandle
					else "fall_left_no_candle"
				)

	# Stop animation when velocity is zero
	if velocity.x == 0 and velocity.y == 0 and not in_non_moving_animation():
		if facingRight:
			update_animation(
				"stand_right" if hasOwnCandle
				else "stand_right_no_candle"
			)
		else:
			update_animation(
				"stand_left" if hasOwnCandle
				else "stand_left_no_candle"
			)
	
	if in_non_moving_animation() and is_finite(non_moving_animation_timer):
		non_moving_animation_timer -= delta

	move_and_slide()

# Function to play animation only if it has changed
func update_animation(animation_name):
	if current_animation != animation_name:
		_animated_sprite.play(animation_name)
		current_animation = animation_name
		non_moving_animation_timer = INF
		if in_non_moving_animation():
			non_moving_animation_timer = (
				NON_MOVING_ANIMATION_DURATIONS[current_animation]
			)

func in_non_moving_animation():
	return NON_MOVING_ANIMATION_DURATIONS.has(current_animation) and (
		non_moving_animation_timer > 0
	)

# Spawn a new candle when "Q" is pressed
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("break_candle") and (
		hasOwnCandle or (heldItem is Candle)
	):
		_spawn_candle()

# Function to spawn a new candle
func _spawn_candle() -> void:
	if hasOwnCandle or (heldItem is Candle):
		# resize held candle
		if not hasOwnCandle: heldItem.initialize(0.5)
		
		# spawn a new candle and resize it to the held candle's scale
		var new_candle = candle_scene.instantiate() as CarriableItem
		new_candle.global_position = global_position
		get_parent().add_child(new_candle)
		new_candle.set_light_scale(
			heldItem.get_light_scale() if heldItem is Candle
			else candle_init_scale
		)
		
		# play break animation
		if facingRight:
			update_animation(&'break_candle_right')
		else:
			update_animation(&'break_candle_left')
		if not hasOwnCandle:
			heldItem.hide_for_break_animation(non_moving_animation_timer)
