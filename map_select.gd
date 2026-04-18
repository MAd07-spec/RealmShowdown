extends Control

const MAP_IDS: Array[String] = ["space", "Japan", "Ocean", "candyland"]

var selected_index := 0
var card_nodes := []

@onready var grid        := $MapGrid
@onready var highlight   := $SelectionHighlight
@onready var confirm_btn := $ConfirmButton
@onready var back_btn    := $BackButton

func _ready() -> void:
	for child in grid.get_children():
		card_nodes.append(child)

	for i in range(card_nodes.size()):
		var map_id: String = MAP_IDS[i]
		var map_data: Dictionary = GameData.maps[map_id]
		var card = card_nodes[i]

		card.get_node("MapName").text = map_data["name"]
		card.get_node("Preview").texture = load(map_data["preview"])

		var btn := Button.new()
		btn.flat = true
		btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		btn.pressed.connect(_on_card_pressed.bind(i))
		card.add_child(btn)

	confirm_btn.pressed.connect(_on_confirm)
	back_btn.pressed.connect(_on_back)
	_select(0)

func _select(index: int) -> void:
	selected_index = index
	GameData.selected_map = MAP_IDS[index]

	var card = card_nodes[index]
	highlight.global_position = card.global_position
	highlight.size = card.size

	for i in range(card_nodes.size()):
		card_nodes[i].modulate = Color(1, 1, 1, 1.0) if i == index else Color(0.5, 0.5, 0.5, 0.8)

func _on_card_pressed(index: int) -> void:
	_select(index)

func _on_confirm() -> void:
	get_tree().change_scene_to_file("res://world.tscn")

func _on_back() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"):
		_select((selected_index + 1) % MAP_IDS.size())
	elif event.is_action_pressed("ui_left"):
		_select((selected_index - 1 + MAP_IDS.size()) % MAP_IDS.size())
	elif event.is_action_pressed("ui_accept"):
		_on_confirm()
