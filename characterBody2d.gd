extends CharacterBody2D

@export var health_bar_path : NodePath
<<<<<<< Updated upstream
@export var speed := 190.0
=======
@export var speed := 200.0
>>>>>>> Stashed changes
@export var attack_damage := 10
@export var max_hp := 100

var hp := max_hp

# Stage bounds
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

	# Initialize health bar
	if health_bar_path != NodePath():
		var bar = get_node(health_bar_path)
		bar.max_value = max_hp
		bar.value = hp


func take_damage(amount: int) -> void:
	hp = clamp(hp - amount, 0, max_hp)

	if health_bar_path != NodePath():
		var bar = get_node(health_bar_path)
		bar.value = hp

	if hp <= 0:
		die()


func die():
	print("Player defeated")
	# Later: disable movement, play KO animation, etc.


func _physics_process(_delta):

	# MOVEMENT
	var direction := 0

	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1

	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

	position.x = clamp(position.x, left_limit, right_limit)

	# ATTACK INPUT
	if Input.is_action_just_pressed("goldy_attack") and not is_attacking:
		start_attack()

	# ANIMATION LOGIC
	if is_attacking:
		if sprite.animation != "goldy_attack":
			sprite.play("goldy_attack")
	else:
		if direction == 0:
			if sprite.animation != "idle":
				sprite.play("idle")
		else:
			if sprite.animation != "goldy_run":
				sprite.play("goldy_run")

	# Flip sprite
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false


func start_attack():
	is_attacking = true
	sprite.play("goldy_attack")

	print("Attack hit! Damage:", attack_damage)

	await sprite.animation_finished
	is_attacking = false
