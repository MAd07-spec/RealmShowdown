extends CanvasLayer

@onready var p1_health_bar  = $P1HealthBar
@onready var p2_health_bar  = $P2HealthBar
@onready var p1_stamina_bar = $P1StaminaBar
@onready var p2_stamina_bar = $P2StaminaBar

func _ready():
	reconnect_players()

func reconnect_players() -> void:
	var p1 = get_node_or_null("/root/World/Player")
	var p2 = get_node_or_null("/root/World/Player2")

	if p1:
		# Disconnect old signals first to avoid duplicates
		if p1.health_changed.is_connected(_on_health_changed):
			p1.health_changed.disconnect(_on_health_changed)
		if p1.stamina_changed.is_connected(_on_stamina_changed):
			p1.stamina_changed.disconnect(_on_stamina_changed)
		p1.health_changed.connect(_on_health_changed)
		p1.stamina_changed.connect(_on_stamina_changed)

	if p2:
		if p2.health_changed.is_connected(_on_health_changed):
			p2.health_changed.disconnect(_on_health_changed)
		if p2.stamina_changed.is_connected(_on_stamina_changed):
			p2.stamina_changed.disconnect(_on_stamina_changed)
		p2.health_changed.connect(_on_health_changed)
		p2.stamina_changed.connect(_on_stamina_changed)

	# Reset bars to full
	p1_health_bar.value  = 100
	p2_health_bar.value  = 100
	p1_stamina_bar.value = 100
	p2_stamina_bar.value = 100

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
