extends Node2D

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
