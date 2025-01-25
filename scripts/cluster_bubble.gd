extends RigidBody2D

var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if not (body is Enemy):
		return
	 
	(body as Enemy).take_damage(damage)
	$AnimationPlayer.play("explode")
