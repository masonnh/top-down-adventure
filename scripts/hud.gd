extends CanvasLayer


const HEART_SIZE: int = 20
var player

const HEART_FULL = preload("res://assets/images/UI/Heart_full.png")
const HEART_HALF = preload("res://assets/images/UI/Heart_half.png")
const HEART_EMPTY = preload("res://assets/images/UI/Heart_empty.png")


@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var hearts_container: HBoxContainer = $Hearts

func set_player(p) -> void:
	player = p
	if player:
		player.health_changed.connect(_update_health)
		_update_health(player.health)

func _update_health(new_health: int) -> void:
	var hearts = hearts_container.get_children()
	var max_hearts = len(hearts)
	var full = int(new_health / HEART_SIZE)
	var half = 1 if (new_health % HEART_SIZE) > 0 else 0
	var empty = max_hearts - (full + half)
	
	# Update full hearts
	for i in full:
		hearts[i].texture = HEART_FULL
	# Update half heart:
	if half:
		hearts[full].texture = HEART_HALF
	# Update empty hearts
	for i in empty:
		hearts[len(hearts) - 1 - i].texture = HEART_EMPTY


func fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade_overlay, "modulate:a", to_alpha, 1.5)
	await tween.finished
