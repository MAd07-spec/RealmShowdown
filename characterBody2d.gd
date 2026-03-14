extends CharacterBody2D

@export var speed := 120.0
@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	var direction = 0

	# INPUT
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	# MOVEMENT
	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

	# ANIMATION
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
