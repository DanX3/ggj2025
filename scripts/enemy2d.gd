class_name Enemy extends CharacterBody2D

@export var damage = 10
@export var SPEED = 100.0

func _physics_process(delta: float) -> void:
	velocity = SPEED * global_position.direction_to(Vector2.ZERO)
	move_and_slide()

func take_damage(damage: int):
	$Health.damage(damage)
	$DamageAnimator.play("take_damage")

func _on_health_died() -> void:
	queue_free()
