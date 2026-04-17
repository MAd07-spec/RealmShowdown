extends CanvasLayer

@onready var p1_bar = $P1HealthBar
@onready var p2_bar = $P2HealthBar

func _ready():
	var p1 = get_node("/root/World/Player")
	var p2 = get_node("/root/World/Player2")
	p1.health_changed.connect(_on_health_changed)
	p2.health_changed.connect(_on_health_changed)

func _on_health_changed(player_id, new_health):
	if player_id == 1:
		p1_bar.value = new_health
	else:
		p2_bar.value = new_health
