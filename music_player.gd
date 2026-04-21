extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_pool_size = 5

var tracks = {
	"menu": preload("res://main-page/titlescreenmusic.mp3"),
	"map_select": preload("res://mapselectionscreen.mp3"),
	"space": preload("res://music/space.mp3"),
	"japan": preload("res://music/japan.mp3"),
	"ocean": preload("res://music/ocean.mp3"),
	"candyland": preload("res://music/candyland.mp3")
}

var sfx = {
	"click": preload("res://music/buttonclick.mp3")
}

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.volume_db = 0
	add_child(music_player)
	# CREATE SFX POOL
	for i in range(sfx_pool_size):
		var p = AudioStreamPlayer.new()
		add_child(p)
		sfx_players.append(p)

func play(track_name: String):
	if not tracks.has(track_name):
		return
	if music_player.stream == tracks[track_name] and music_player.playing:
		return
	music_player.stream = tracks[track_name]
	music_player.play()

func stop():
	music_player.stop()

func play_sfx(sfx_name: String):
	if not sfx.has(sfx_name):
		return
	# FIND A FREE PLAYER IN THE POOL
	for p in sfx_players:
		if not p.playing:
			p.stream = sfx[sfx_name]
			p.play()
			return

func play_sound(stream: AudioStream):
	# PLAY A DIRECT STREAM (for character sounds)
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.play()
			return
