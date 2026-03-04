extends CharacterBody2D

@export var speed := 120.0
@onready var sprite = $AnimatedSprite2D

var is_attacking := false

func _physics_process(_delta):
	var direction = 0

	# INPUT
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	# ATTACK INPUT (priority)
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()
		return  # stop other actions while attacking

	# MOVEMENT (disabled while attacking)
	if not is_attacking:
		velocity.x = direction * speed
	else:
		velocity.x = 0

	velocity.y = 0
	move_and_slide()

	# ANIMATION STATE
	if not is_attacking:
		if direction == 0:
			if sprite.animation != "idle":
				sprite.play("idle")
		else:
			if sprite.animation != "running":
				sprite.play("running")

	# FLIP
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false


func start_attack():
	is_attacking = true
	sprite.play("attack")

	# Wait for animation to finish, then return to idle
	await sprite.animation_finished
	is_attacking = false
