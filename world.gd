extends Node

@onready var player1 = $Player
@onready var player2 = $Player2
@onready var hud     = $HUD

func _ready() -> void:
	player2.position.x = 800.0
	player2.facing_dir = -1
	player2.sprite.flip_h = true
	player1.opponent = player2
	player2.opponent = player1
	hud.setup(player1, player2)
