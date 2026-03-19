extends CharacterBody2D
var speed = 300.0
var is_attacking = false
var attack_damage = 10
var jump_force = -1450.0
var gravity_scale = 4.5
@onready var sprite = $AnimatedSprite2D
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
	if Input.is_action_pressed("ui_right"):
		direction = 1
	if Input.is_action_pressed("ui_left"):
		direction = -1
	velocity.x = direction * speed

	# JUMP
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()
	# BOUNDARIES
	#dadaaposition.x = clamp(position.x, -740, 740)
	# ATTACK
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		sprite.play("attack")
		print("Attack hit! Damage:", attack_damage)
	# ANIMATIONS
	if is_attacking:
		if not sprite.is_playing():
			is_attacking = false
	elif direction == 1:
		sprite.play("running")
	elif direction == -1:
		sprite.play("running")
	else:
		sprite.play("idle")
	
	# FLIP - face player 2 unless moving away
	var p2 = get_node("/root/World/Player2")
	if direction == 0:
		if p2.position.x < position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		if direction == 1:
			sprite.flip_h = false
		elif direction == -1:
			sprite.flip_h = true
		
