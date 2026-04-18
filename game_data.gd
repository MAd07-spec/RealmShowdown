# GameData.gd
extends Node

var selected_map: String = "space"  # default map

# Map registry: id → { name, scene_path, preview_texture }
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
