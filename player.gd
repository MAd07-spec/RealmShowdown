extends CharacterBody2D

@export var player_id: int = 1
var speed = 300.0
var is_attacking = false
var attack_damage = 10
var jump_force = -1550.0
var gravity_scale = 4.0
var max_health = 100
var current_health = 100
var already_hit = false  
var max_stamina = 100.0
var current_stamina = 100.0
var stamina_regen_rate = 15.0 
var is_hurt = false
var was_running := false

@onready var sprite        = $AnimatedSprite2D
@onready var hitbox        = $AttackHitbox
@onready var audio_attack  = $AudioAttack
@onready var audio_hurt    = $AudioHurt
@onready var audio_die     = $AudioDie
@onready var audio_run     = $AudioRun

var action_left: String
var action_right: String
var action_jump: String
var action_attack: String

signal health_changed(player_id, new_health)
signal player_died(player_id)
signal stamina_changed(player_id, new_stamina)

# INITIALISE PLAYER INPUTS AND HITBOX
func _ready():
	action_left   = "p%d_left"   % player_id
	action_right  = "p%d_right"  % player_id
	action_jump   = "p%d_jump"   % player_id
	action_attack = "p%d_attack" % player_id
	hitbox.monitoring = false  
	hitbox.body_entered.connect(_on_attack_hitbox_body_entered)
	
	# LOAD CHARACTER SPRITES BASED ON SELECTION
	var character_key = GameData.p1_character if player_id == 1 else GameData.p2_character
	sprite.frames = GameData.characters[character_key]["frames"]
	sprite.scale = GameData.characters[character_key]["scale"]
	sprite.position = GameData.characters[character_key]["sprite_offset"]
	sprite.play("idle")

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

	# STAMINA REGEN
	if not is_attacking:
		current_stamina = min(current_stamina + stamina_regen_rate * delta, max_stamina)
		emit_signal("stamina_changed", player_id, current_stamina)

	# JUMP
	if Input.is_action_just_pressed(action_jump) and is_on_floor():
		velocity.y = jump_force
	move_and_slide()

	# ATTACK
	if Input.is_action_just_pressed(action_attack) and not is_attacking and not is_hurt and current_stamina > 0:
		is_attacking = true
		already_hit = false
		current_stamina -= 20.0
		current_stamina = max(current_stamina, 0.0)
		emit_signal("stamina_changed", player_id, current_stamina)
		sprite.play("attack")
		audio_attack.play()
		print("Player %d Attack! Damage: %d" % [player_id, attack_damage])
		await get_tree().create_timer(0.15).timeout
		enable_hitbox()

	# ANIMATIONS
	if is_hurt:
		if not sprite.is_playing():
			is_hurt = false
	elif is_attacking:
		if not sprite.is_playing():
			is_attacking = false
			hitbox.monitoring = false
			already_hit = false
	elif direction != 0:
		sprite.play("running")
		# Only trigger run sound when starting to run, not every frame
		if not was_running and is_on_floor():
			audio_run.play()
		was_running = true
	else:
		sprite.play("idle")
		was_running = false

	# FLIP - face the opponent
	var opponent_path = "/root/World/Player" if player_id == 2 else "/root/World/Player2"
	var opponent = get_node_or_null(opponent_path)
	if opponent:
		if direction == 0:
			sprite.flip_h = opponent.position.x < position.x
		else:
			sprite.flip_h = direction == -1
			# OVERRIDE - if moving but opponent crossed sides, flip instantly
			if direction == 1 and opponent.position.x < position.x:
				sprite.flip_h = true
			elif direction == -1 and opponent.position.x > position.x:
				sprite.flip_h = false

	# POSITION HITBOX IN FRONT OF PLAYER
	if sprite.flip_h:
		hitbox.position.x = -40
	else:
		hitbox.position.x = 40

func enable_hitbox():
	if not already_hit and current_stamina > 0:
		hitbox.monitoring = true

func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)
	emit_signal("health_changed", player_id, current_health)
	print("Player %d took %d damage, health: %d" % [player_id, amount, current_health])
	if current_health <= 0:
		audio_die.play()
		await audio_die.finished
		emit_signal("player_died", player_id)
		print("Player %d has died!" % player_id)
		queue_free()
	else:
		is_hurt = true
		audio_hurt.play()
		sprite.play("hurt")

func _on_attack_hitbox_body_entered(body):
	print("Hitbox hit: ", body.name)
	if already_hit:
		return
	if body.has_method("take_damage") and body.player_id != player_id:
		body.take_damage(attack_damage)
		already_hit = true
		hitbox.monitoring = false
