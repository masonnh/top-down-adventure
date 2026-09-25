extends CanvasLayer


@onready var fade_overlay: ColorRect = $FadeOverlay


func fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade_overlay, "modulate:a", to_alpha, 1.5)
	await tween.finished
