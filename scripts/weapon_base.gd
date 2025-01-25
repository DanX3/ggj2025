extends Node2D

var bubbleScene = preload("res://scenes/inflatable_bubble.tscn")
@onready var arrowPivot := $ArrowPivot
@onready var spawn = $ArrowPivot/Arrow/SpawnPoint
var bubble: RigidBody2D = null
var arrowDir := Vector2.ZERO
const ShootForce = 1000


func _physics_process(delta: float) -> void:
	arrowDir = Vector2(Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down"))
	if bubble != null:
		bubble.global_position = spawn.global_position
	
	if arrowDir.length_squared() > 0.3:
		arrowPivot.rotation = atan2(arrowDir.y, arrowDir.x)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("trigger"):
		bubble = Utils.spawn_child(spawn.global_position, self, bubbleScene)
	
	if Input.is_action_just_released("trigger") and bubble != null:
		bubble.apply_central_impulse(ShootForce * arrowDir)
		bubble.stop_inflating()
		bubble = null
