extends RigidBody2D

var damage = 3

func scale_size(scale: float):
	($CollisionShape2D.shape as CircleShape2D).radius *= scale
	$Sprite2D.scale *= scale
	

func _on_body_entered(body: Node) -> void:
	if not (body is Enemy):
		return
	 
	(body as Enemy).take_damage(damage)
	$AnimationPlayer.play("explode")
