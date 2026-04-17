extends CharacterBody2D

# --- Stats ---
@export var speed         := 190.0
@export var attack_damage := 10
@export var max_health    := 100

# --- Input Actions ---
@export var action_left   := "p1_left"
@export var action_right  := "p1_right"
@export var action_attack := "p1_attack"

# --- Opponent Reference (assigned by world.gd) ---
var opponent : CharacterBody2D = null

# --- Stage Bounds ---
var stage_left  := -1000.0
var stage_right :=  1000.0
var left_limit  : float
var right_limit : float

# --- State ---
var is_attacking   : bool = false
var is_hurt        : bool = false
var is_dead        : bool = false
var facing_dir     : int  = 1
var current_health : int

# --- Signals ---
signal health_changed(new_health: int)
signal player_died

@onready var sprite       : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox       : Area2D           = $Hitbox
@onready var hurtbox      : Area2D           = $Hurtbox
@onready var hitbox_shape : CollisionShape2D = $Hitbox/CollisionShape2D2

# ---------------------------------------------------------------
func _ready() -> void:
	var half_screen = get_viewport_rect().size.x / 2
	left_limit  = stage_left  + half_screen
	right_limit = stage_right - half_screen
	current_health = max_health

	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)

	hurtbox.area_entered.connect(_on_hurtbox_area_entered)

	sprite.flip_h = facing_dir == -1
	_flip_hitbox(facing_dir)

# ---------------------------------------------------------------
func _physics_process(_delta: float) -> void:
	if is_dead or is_hurt:
		velocity.x = 0
		move_and_slide()
		return

	var direction := 0
	if Input.is_action_pressed(action_right): direction += 1
	if Input.is_action_pressed(action_left):  direction -= 1

	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()


	# Block movement through opponent
	if opponent and is_instance_valid(opponent):
		var min_dist := 80.0
		var dist = position.x - opponent.position.x
		if abs(dist) < min_dist:
			if dist >= 0:
				position.x = opponent.position.x + min_dist
			else:
				position.x = opponent.position.x - min_dist
			position.x = clamp(position.x, left_limit, right_limit)

	if Input.is_action_just_pressed(action_attack) and not is_attacking:
		start_attack()

	_update_animation(direction)
	_update_facing(direction)

# ---------------------------------------------------------------
func _update_facing(direction: int) -> void:
	if direction == 0:
		# Standing still — face the opponent automatically
		if opponent and is_instance_valid(opponent):
			if opponent.position.x < position.x:
				sprite.flip_h = true
				if facing_dir != -1:
					facing_dir = -1
					_flip_hitbox(-1)
			else:
				sprite.flip_h = false
				if facing_dir != 1:
					facing_dir = 1
					_flip_hitbox(1)
	elif direction < 0:
		sprite.flip_h = true
		if facing_dir != -1:
			facing_dir = -1
			_flip_hitbox(-1)
	elif direction > 0:
		sprite.flip_h = false
		if facing_dir != 1:
			facing_dir = 1
			_flip_hitbox(1)

# ---------------------------------------------------------------
func _flip_hitbox(dir: int) -> void:
	var shape = get_node_or_null("Hitbox/CollisionShape2D2")
	if shape == null:
		push_error(name + ": Could not find Hitbox/CollisionShape2D2")
		return
	shape.position.x = abs(shape.position.x) * dir

# ---------------------------------------------------------------
func _update_animation(direction: int) -> void:
	if is_attacking:
		if sprite.animation != "attack":
			sprite.play("attack")
	elif direction == 0:
		if sprite.animation != "idle":
			sprite.play("idle")
	else:
		if sprite.animation != "running":
			sprite.play("running")

# ---------------------------------------------------------------
func start_attack() -> void:
	is_attacking = true
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)
	sprite.play("attack")
	await sprite.animation_finished
	if not is_dead:
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
		is_attacking = false

# ---------------------------------------------------------------
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area == hitbox:
		return
	if is_dead:
		return
	var attacker = area.get_parent()
	if attacker and attacker.has_method("get_attack_damage"):
		take_damage(attacker.get_attack_damage())

func get_attack_damage() -> int:
	return attack_damage

# ---------------------------------------------------------------
func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_health = clamp(current_health - amount, 0, max_health)
	health_changed.emit(current_health)
	if current_health == 0:
		die()
	else:
		play_hurt()

# ---------------------------------------------------------------
func play_hurt() -> void:
	if is_hurt:
		return
	is_hurt = true
	is_attacking = false
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	sprite.play("hurt")
	await sprite.animation_finished
	if not is_dead:
		is_hurt = false

# ---------------------------------------------------------------
func heal(amount: int) -> void:
	if is_dead:
		return
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit(current_health)

# ---------------------------------------------------------------
func die() -> void:
	is_dead      = true
	is_hurt      = false
	is_attacking = false
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)
	sprite.play("death")
	player_died.emit()
	await sprite.animation_finished
	queue_free()
