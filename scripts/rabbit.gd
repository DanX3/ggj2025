extends Enemy

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_timer_timeout() -> void:
	var playerPos = get_tree().get_first_node_in_group("player").global_position
	velocity = SPEED * global_position.direction_to(playerPos)
	$Sprite2D.hide()
	$SpriteJump.show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "velocity", Vector2.ZERO, 1.0)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func(): 
		$Sprite2D.show()
		$SpriteJump.hide())
