extends Control

func _ready() -> void:
	MusicManager.play("menu")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main-page/char_select.tscn")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://map_select.tscn")
