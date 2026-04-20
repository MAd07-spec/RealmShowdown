extends Node2D

@onready var round_manager := $RoundManager

var p1_start_pos := Vector2(-441, 1)
var p2_start_pos := Vector2(157, -2)

func _ready() -> void:
	_load_map_background()
	_set_players_active(false)  # disabled until round starts
	round_manager.round_started.connect(_on_round_started)
	_connect_player_signals()


func _load_map_background() -> void:
	var map_id: String = GameData.selected_map
	var map_data: Dictionary = GameData.maps[map_id]

	var bg_texture := load(map_data["preview"]) as Texture2D

	if bg_texture:
		$Background.texture = bg_texture
	else:
		push_error("Could not load background for map: " + map_id)


func _connect_player_signals() -> void:
	var p1 = get_node_or_null("Player")
	var p2 = get_node_or_null("Player2")
	if p1:
		p1.player_died.connect(_on_player_died)
	if p2:
		p2.player_died.connect(_on_player_died)


func _on_player_died(player_id: int) -> void:
	_set_players_active(false)
	round_manager.show_round_end(player_id)


func _on_round_started() -> void:
	_respawn_players()
	_set_players_active(true)


func _respawn_players() -> void:
	var old_p1 = get_node_or_null("Player")
	var old_p2 = get_node_or_null("Player2")
	if old_p1:
		old_p1.queue_free()
	if old_p2:
		old_p2.queue_free()

	await get_tree().process_frame

	var p1_scene := load("res://Player.tscn") as PackedScene
	var p2_scene := load("res://Player_two.tscn") as PackedScene

	var p1 = p1_scene.instantiate()
	var p2 = p2_scene.instantiate()

	p1.position = p1_start_pos
	p2.position = p2_start_pos

	add_child(p1)
	add_child(p2)

	await get_tree().process_frame

	# Reconnect HUD to new player instances
	$hud.reconnect_players()
	_connect_player_signals()


func _set_players_active(active: bool) -> void:
	var p1 = get_node_or_null("Player")
	var p2 = get_node_or_null("Player2")
	if p1:
		p1.set_physics_process(active)
		p1.set_process_input(active)
	if p2:
		p2.set_physics_process(active)
		p2.set_process_input(active)


func _process(_delta):
	# RESET
	if Input.is_action_just_pressed("reset"):
		GameData.reset_rounds()
		get_tree().reload_current_scene()
