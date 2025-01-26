extends Enemy


func _ready() -> void:
	$Timer.wait_time = randf_range(0.01, 0.5)
	$Timer.start()


func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("default")
