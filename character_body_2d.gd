extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 980.0

func _physics_process(delta: float) -> void:
	# Apply gravity when not on floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("jump_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Left / Right movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = direction * SPEED
		# Flip sprite to face direction
		$Sprite2D.flip_h = direction < 0
	else:
		# Friction / deceleration
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
