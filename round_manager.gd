extends CanvasLayer

signal round_started
signal game_over

var waiting_for_input := false
var is_match_over := false

@onready var overlay       := $Overlay
@onready var round_label   := $RoundLabel
@onready var message_label := $MessageLabel
@onready var prompt_label  := $PromptLabel

func _ready() -> void:
	overlay.color = Color(0, 0, 0, 1)
	round_label.visible   = false
	message_label.visible = false
	prompt_label.visible  = false
	await get_tree().process_frame
	show_round_start()


func show_round_start() -> void:
	is_match_over = false
	round_label.text  = "Round %d of %d" % [GameData.current_round, GameData.max_rounds]
	message_label.text = ""
	prompt_label.text = "Press any key to fight!"

	round_label.visible   = true
	message_label.visible = false
	prompt_label.visible  = true
	waiting_for_input     = true


func show_round_end(loser_id: int) -> void:
	var winner_id := 2 if loser_id == 1 else 1
	if winner_id == 1:
		GameData.p1_wins += 1
	else:
		GameData.p2_wins += 1

	await fade_in()

	message_label.text = "Player %d wins the round!" % winner_id
	round_label.text   = "P1 Wins: %d   P2 Wins: %d" % [GameData.p1_wins, GameData.p2_wins]
	message_label.visible = true
	round_label.visible   = true

	# Check if match is over
	if GameData.p1_wins >= 2 or GameData.p2_wins >= 2 or GameData.current_round >= GameData.max_rounds:
		await get_tree().create_timer(1.5).timeout
		show_match_winner()
		return

	GameData.current_round += 1
	prompt_label.text    = "Press any key for Round %d" % GameData.current_round
	prompt_label.visible = true
	waiting_for_input    = true


func show_match_winner() -> void:
	var winner_id := 1 if GameData.p1_wins > GameData.p2_wins else 2
	message_label.text = "Player %d wins the match!" % winner_id
	round_label.text   = "Final Score — P1: %d  P2: %d" % [GameData.p1_wins, GameData.p2_wins]
	prompt_label.text  = "Press any key to return to menu"
	message_label.visible = true
	round_label.visible   = true
	prompt_label.visible  = true
	is_match_over     = true
	waiting_for_input = true
	emit_signal("game_over")


func _input(event: InputEvent) -> void:
	if not waiting_for_input:
		return
	if not (event is InputEventKey and event.pressed):
		return

	waiting_for_input = false

	if is_match_over:
		GameData.reset_rounds()
		get_tree().change_scene_to_file("res://main-page/mainpage.tscn")
		return

	# Hide UI and fade out
	round_label.visible   = false
	message_label.visible = false
	prompt_label.visible  = false

	await fade_out()
	emit_signal("round_started")


func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 0.6)
	await tween.finished


func fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0), 0.6)
	await tween.finished
