extends CharacterBody2D


const SPEED = 100.0


func _physics_process(delta: float) -> void:
	velocity = SPEED * global_position.direction_to(Vector2.ZERO)
	move_and_slide()
