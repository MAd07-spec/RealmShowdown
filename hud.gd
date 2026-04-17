extends CanvasLayer

@onready var p1_health_bar = $P1HealthBar
@onready var p2_health_bar = $P2HealthBar
@onready var p1_stamina_bar = $P1StaminaBar
@onready var p2_stamina_bar = $P2StaminaBar

func _ready():
	var p1 = get_node("/root/World/Player")
	var p2 = get_node("/root/World/Player2")
	p1.health_changed.connect(_on_health_changed)
	p2.health_changed.connect(_on_health_changed)
	p1.stamina_changed.connect(_on_stamina_changed)
	p2.stamina_changed.connect(_on_stamina_changed)

func _on_health_changed(player_id, new_health):
	if player_id == 1:
		p1_health_bar.value = new_health
	else:
		p2_health_bar.value = new_health

func _on_stamina_changed(player_id, new_stamina):
	if player_id == 1:
		p1_stamina_bar.value = new_stamina
	else:
		p2_stamina_bar.value = new_stamina
