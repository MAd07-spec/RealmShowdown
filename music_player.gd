extends Node

var music_player: AudioStreamPlayer

var tracks = {
	"menu": preload("res://main-page/titlescreenmusic.mp3"),
	"map_select": preload("res://mapselectionscreen.mp3"),
	"space": preload("res://music/space.mp3"),
	"japan": preload("res://music/japan.mp3"),
	"ocean": preload("res://music/ocean.mp3"),
	"candyland": preload("res://music/candyland.mp3")
}

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = 0
	add_child(music_player)

func play(track_name: String):
	if not tracks.has(track_name):
		return
	# DONT RESTART IF SAME TRACK IS ALREADY PLAYING
	if music_player.stream == tracks[track_name] and music_player.playing:
		return
	music_player.stream = tracks[track_name]
	music_player.play()

func stop():
	music_player.stop()
