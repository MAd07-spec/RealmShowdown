extends Control

const CHAR_IDS: Array[String] = ["alien", "knight", "sensei", "goldy"]

var p1_index := 0
var p2_index := 1
var p1_confirmed := false
var p2_confirmed := false

var p1_cards: Array[Control] = []
var p2_cards: Array[Control] = []

@onready var p1_grid     := $P1Side/P1Grid
@onready var p2_grid     := $P2Side/P2Grid
@onready var p1_preview  := $P1Side/P1Preview
@onready var p2_preview  := $P2Side/P2Preview
@onready var p1_name     := $P1Side/P1Name
@onready var p2_name     := $P2Side/P2Name
@onready var p1_confirm := $P1Side/P1Confirm
@onready var p2_confirm := $P2Side/P2Confirm

func _ready() -> void:
	MusicManager.play("menu")
	for child in p1_grid.get_children():
		p1_cards.append(child)
	for child in p2_grid.get_children():
		p2_cards.append(child)

	for i in range(p1_cards.size()):
		var char_id: String = CHAR_IDS[i]
		var char_data: Dictionary = GameData.characters[char_id]

		var p1_card: Control = p1_cards[i]
		p1_card.get_node("CharName").text = char_data["name"]
		p1_card.get_node("Preview").texture = load(char_data["preview"])
		var p1_btn := Button.new()
		p1_btn.flat = true
		p1_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		p1_btn.pressed.connect(_p1_select.bind(i))
		p1_card.add_child(p1_btn)

		var p2_card: Control = p2_cards[i]
		p2_card.get_node("CharName").text = char_data["name"]
		p2_card.get_node("Preview").texture = load(char_data["preview"])
		var p2_btn := Button.new()
		p2_btn.flat = true
		p2_btn.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		p2_btn.pressed.connect(_p2_select.bind(i))
		p2_card.add_child(p2_btn)

	p1_confirm.pressed.connect(_p1_confirm)
	p2_confirm.pressed.connect(_p2_confirm)
	_reset_confirm_buttons()
	_update_p1(0)
	_update_p2(1)


func _update_p1(index: int) -> void:
	p1_index = index
	var char_data: Dictionary = GameData.characters[CHAR_IDS[index]]
	p1_preview.texture = load(char_data["preview"])
	p1_name.text = char_data["name"]
	for i in range(p1_cards.size()):
		p1_cards[i].modulate = Color(1, 1, 1, 1.0) if i == index else Color(0.5, 0.5, 0.5, 0.8)


func _update_p2(index: int) -> void:
	p2_index = index
	var char_data: Dictionary = GameData.characters[CHAR_IDS[index]]
	p2_preview.texture = load(char_data["preview"])
	p2_name.text = char_data["name"]
	for i in range(p2_cards.size()):
		p2_cards[i].modulate = Color(1, 1, 1, 1.0) if i == index else Color(0.5, 0.5, 0.5, 0.8)


func _p1_select(index: int) -> void:
	if not p1_confirmed:
		_update_p1(index)


func _p2_select(index: int) -> void:
	if not p2_confirmed:
		_update_p2(index)


func _p1_confirm() -> void:
	p1_confirmed = true
	p1_confirm.text = "P1: Ready!"
	p1_confirm.modulate = Color(0.2, 1.0, 0.2)  # turns green
	_check_both_confirmed()


func _p2_confirm() -> void:
	p2_confirmed = true
	p2_confirm.text = "P2: Ready!"
	p2_confirm.modulate = Color(0.2, 1.0, 0.2)  # turns green
	_check_both_confirmed()


func _reset_confirm_buttons() -> void:
	p1_confirm.text = "P1: Press Q to confirm"
	p2_confirm.text = "P2: Press Enter to confirm"
	p1_confirm.modulate = Color(1, 1, 1)
	p2_confirm.modulate = Color(1, 1, 1)


func _check_both_confirmed() -> void:
	if p1_confirmed and p2_confirmed:
		GameData.p1_character = CHAR_IDS[p1_index]
		GameData.p2_character = CHAR_IDS[p2_index]
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://map_select.tscn")


func _input(event: InputEvent) -> void:
	# P1 navigation — A/D keys
	if event.is_action_pressed("p1_right"):
		if not p1_confirmed:
			_update_p1((p1_index + 1) % CHAR_IDS.size())
	elif event.is_action_pressed("p1_left"):
		if not p1_confirmed:
			_update_p1((p1_index - 1 + CHAR_IDS.size()) % CHAR_IDS.size())
	elif event.is_action_pressed("p1_confirm"):
		_p1_confirm()

	# P2 navigation — Arrow keys
	if event.is_action_pressed("p2_right"):
		if not p2_confirmed:
			_update_p2((p2_index + 1) % CHAR_IDS.size())
	elif event.is_action_pressed("p2_left"):
		if not p2_confirmed:
			_update_p2((p2_index - 1 + CHAR_IDS.size()) % CHAR_IDS.size())
	elif event.is_action_pressed("p2_confirm"):
		_p2_confirm()
