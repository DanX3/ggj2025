class_name Enemy extends CharacterBody2D

var damageLabelScene = preload("res://library/scenes/damage_label.tscn")
@export var damage = 10
const SPEED = 100.0

func _physics_process(delta: float) -> void:
	velocity = SPEED * global_position.direction_to(Vector2.ZERO)
	move_and_slide()

func take_damage(damage: int):
	$Health.damage(damage)

func _on_health_died() -> void:
	queue_free()
