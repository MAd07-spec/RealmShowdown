extends Node

var selected_map: String = "space"
var p1_character: String = "alien"
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
		"scene": "res://candyland.tscn",
		"preview": "res://maps/candy-land.png"
	}
}

var characters := {
	"alien": {
		"name": "Alien",
		"scene": "res://Player.tscn",
		"preview": "res://alien/fightersprite.png"
	},
	"knight": {
		"name": "Knight",
		"scene": "res://Player2.tscn",
		"preview": "res://knight/knight-preview.png"
	},
	"sensei": {
		"name": "Sensei",
		"scene": "res://Player3.tscn",
		"preview": "res://sensei/sensei-preview.png"
	},
	"goldy": {
		"name": "Goldy",
		"scene": "res://Player4.tscn",
		"preview": "res://goldy/goldy-preview.png"
	}
}
