extends CharacterBody3D

const SPEED = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = 20 * global_position.direction_to(Vector3.ZERO)
	move_and_slide()
