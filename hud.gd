extends CanvasLayer

@onready var p1_bar: ProgressBar = $Control/P1Container/P1VBox/P1HealthBar
@onready var p2_bar: ProgressBar = $Control/P2Container/P2VBox/P2HealthBar

func setup(player1: Node, player2: Node) -> void:
	p1_bar.max_value = player1.max_health
	p1_bar.value     = player1.current_health

	p2_bar.max_value = player2.max_health
	p2_bar.value     = player2.current_health

	player1.health_changed.connect(_on_p1_health_changed)
	player2.health_changed.connect(_on_p2_health_changed)

func _on_p1_health_changed(new_health: int) -> void:
	_animate_bar(p1_bar, new_health)

func _on_p2_health_changed(new_health: int) -> void:
	_animate_bar(p2_bar, new_health)

func _animate_bar(bar: ProgressBar, target: int) -> void:
	var tween = create_tween()
	tween.tween_property(bar, "value", target, 0.2) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
