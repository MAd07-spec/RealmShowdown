extends CharacterBody2D

@export var speed := 190.0
@export var attack_damage := 10

# Stage bounds (must match camera setup)
var stage_left := -1000.0
var stage_right := 1000.0

var left_limit : float
var right_limit : float

var is_attacking := false

@onready var sprite = $AnimatedSprite2D


func _ready():
	var half_screen = get_viewport_rect().size.x / 2
	left_limit = stage_left + half_screen
	right_limit = stage_right - half_screen


func _physics_process(_delta):

	# ----------------
	# MOVEMENT
	# ----------------
	var direction = 0

	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

	position.x = clamp(position.x, left_limit, right_limit)

	# ----------------
	# ATTACK INPUT
	# ----------------
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()

	# ----------------
	# ANIMATION LOGIC
	# ----------------
	if is_attacking:
		# Attack overrides everything
		if sprite.animation != "attack":
			sprite.play("attack")
	else:
		if direction == 0:
			if sprite.animation != "idle":
				sprite.play("idle")
		else:
			if sprite.animation != "running":
				sprite.play("running")

	# Flip sprite
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false


func start_attack():
	is_attacking = true
	sprite.play("attack")

	# 👇 Hard-coded damage example (for now just print)
	print("Attack hit! Damage:", attack_damage)

	await sprite.animation_finished
	is_attacking = false
