class_name PowerupCard extends Panel

signal chosen

func apply_card(player: Player):
	pass


func _on_button_pressed() -> void:
	emit_signal("chosen")


func animate_chosen():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2.DOWN * 200, 0.2).as_relative()\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "position", Vector2.UP * 1200, 0.3).as_relative()\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		

func animate_discard():
	$AnimationPlayer.play("discard")
