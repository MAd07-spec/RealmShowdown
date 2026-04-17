extends CharacterBody2D

@export var player_id: int = 1

var speed = 300.0
var is_attacking = false
var attack_damage = 10
var jump_force = -1550.0
var gravity_scale = 4.0
var max_health = 100
var current_health = 100
var already_hit = false  # prevents multiple hits per swing

@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $AttackHitbox  # Area2D you'll add

var action_left: String
var action_right: String
var action_jump: String
var action_attack: String

signal health_changed(player_id, new_health)
signal player_died(player_id)


# INITIALISE PLAYER INPUTS AND HITBOX
func _ready():
	action_left   = "p%d_left"   % player_id
	action_right  = "p%d_right"  % player_id
	action_jump   = "p%d_jump"   % player_id
	action_attack = "p%d_attack" % player_id
	
	hitbox.monitoring = false  
	hitbox.body_entered.connect(_on_attack_hitbox_body_entered)

func _physics_process(delta):
	floor_stop_on_slope = false
	floor_block_on_wall = false

	# GRAVITY
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_scale
	else:
		velocity.y = 0

	# MOVEMENT
	var direction = 0
	if Input.is_action_pressed(action_right):
		direction = 1
	if Input.is_action_pressed(action_left):
		direction = -1
	velocity.x = direction * speed

	# JUMP
	if Input.is_action_just_pressed(action_jump) and is_on_floor():
		velocity.y = jump_force
	move_and_slide()

	# ATTACK
	if Input.is_action_just_pressed(action_attack) and not is_attacking:
		is_attacking = true
		already_hit = false
		sprite.play("attack")
		print("Player %d Attack! Damage: %d" % [player_id, attack_damage])
		await get_tree().create_timer(0.15).timeout
		enable_hitbox()

	# ANIMATIONS
	if is_attacking:
		if not sprite.is_playing():
			is_attacking = false
			hitbox.monitoring = false
			already_hit = false
	elif direction != 0:
		sprite.play("running")
	else:
		sprite.play("idle")

	# FLIP - face the opponent
	var opponent_path = "/root/World/Player" if player_id == 2 else "/root/World/Player2"
	var opponent = get_node(opponent_path)
	if direction == 0:
		if opponent:
			sprite.flip_h = opponent.position.x < position.x
	else:
		sprite.flip_h = direction == -1

	# Position hitbox in front of player
	if sprite.flip_h:
		hitbox.position.x = -40
	else:
		hitbox.position.x = 40

func enable_hitbox():
	if not already_hit:
		hitbox.monitoring = true

func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)
	emit_signal("health_changed", player_id, current_health)
	print("Player %d took %d damage, health: %d" % [player_id, amount, current_health])
	if current_health <= 0:
		emit_signal("player_died", player_id)
		print("Player %d has died!" % player_id)
		#here is where the player dissapears after reacheing 0 health
		visible = false
		queue_free()
		

func _on_attack_hitbox_body_entered(body):
	print("Hitbox hit: ", body.name)
	if already_hit:
		return
	if body.has_method("take_damage") and body.player_id != player_id:
		body.take_damage(attack_damage)
		already_hit = true
		hitbox.monitoring = false
