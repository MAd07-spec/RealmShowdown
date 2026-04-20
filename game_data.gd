extends Node

var selected_map: String = "space"
var p1_character: String = "sensei"
var p2_character: String = "knight"

var maps := {
	"space": {
		"name": "Space Splatter",
		"scene": "res://space.tscn",
		"preview": "res://maps/spaceBG.png"
	},
	"Japan": {
		"name": "Japan Jams",
		"scene": "res://japan.tscn",
		"preview": "res://maps/Japanbg.png"
	},
	"Ocean": {
		"name": "Ocean Opus",
		"scene": "res://ocean.tscn",
		"preview": "res://maps/Ocean-map.jpg"
	},
	"candyland": {
		"name": "Candy Chaos",
		"scene": "res://candlyland.tscn",
		"preview": "res://maps/candlyland.png"
	}
}

var characters := {
	"alien": {
		"name": "Alien",
		"frames": preload("res://alien/alien_frames.tres"),
		"preview": "res://alien/fightersprite.png",
		"scale": Vector2(0.29, 0.29),
		"sprite_offset": Vector2(70.0, -105.0)
		
		
	},
	"knight": {
		"name": "Knight",
		"frames": preload("res://knight/knight_frames.tres"),
		"preview": "res://knight/knight-preview.png",
		"scale": Vector2(4.737, 6.276),
		"sprite_offset": Vector2(70.0, -110.0)
		

	},
	"sensei": {
		"name": "Sensei",
		"frames": preload("res://sensei/sensei_frames.tres"),
		"preview": "res://sensei/sensei-preview.png",
		"scale": Vector2(6.63, 8.274),
		"sprite_offset": Vector2(59.766, -232.867)
		

	},
	"goldy": {
		"name": "Goldy",
		"frames": preload("res://goldy/goldy_frames.tres"),
		"preview": "res://goldy/goldy-preview.png",
		"scale": Vector2(3.50, 3.50),
		"sprite_offset": Vector2(70.0, -220.0)
		

	}
}
