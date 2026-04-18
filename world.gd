extends Node

<<<<<<< Updated upstream
@onready var player1 = $Player
@onready var player2 = $Player2
@onready var hud     = $HUD

func _ready() -> void:
	player2.position.x = 800.0
	player2.facing_dir = -1
	player2.sprite.flip_h = true
	player1.opponent = player2
	player2.opponent = player1
	hud.setup(player1, player2)
=======
func _ready() -> void:
	_load_map_background()

func _load_map_background() -> void:
	var map_id := GameData.selected_map
	var map_data: Dictionary = GameData.maps[map_id]

	var bg_texture := load(map_data["preview"]) as Texture2D

	if bg_texture:
		$Background.texture = bg_texture
	else:
		push_error("Could not load background for map: " + map_id)

func _process(_delta):
	# RESET
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
>>>>>>> Stashed changes
