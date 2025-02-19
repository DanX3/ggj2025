extends Weapon

var bubbleScene = preload("res://scenes/inflatable_bubble.tscn")
@onready var arrowPivot := $ArrowPivot
@onready var spawn = $ArrowPivot/Arrow/SpawnPoint
var bubble: RigidBody2D = null
var arrowDir := Vector2.ZERO
var ShootForce = 1000
@export var damage = 10
var multiplierGrowth := 1.0
var explosionSizeMult = 1.0

var mouseDir := Vector2.ZERO

func _physics_process(delta: float) -> void:
	arrowDir = Vector2(Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down"))
	if bubble != null:
		bubble.global_position = spawn.global_position
	
	var aimDir = mouseDir if mouseDir.length_squared() > 0.0 else arrowDir
	
	if aimDir.length_squared() > 0.3:
		arrowPivot.rotation = atan2(aimDir.y, aimDir.x)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion = event as InputEventMouseMotion
		mouseDir = global_position.direction_to(get_global_mouse_position())
	
	if not enabled or not $Cooldown.is_ready():
		return
		
	if Input.is_action_just_pressed("trigger"):
		_trigger_down()
	
	if Input.is_action_just_released("trigger"):
		_trigger_up()

func _unhandled_input(event: InputEvent) -> void:
	if not enabled or not $Cooldown.is_ready():
		return
	
	if Input.is_action_just_pressed("trigger"):
		_trigger_down()
	
	if Input.is_action_just_released("trigger"):
		_trigger_up()

func _trigger_down():
	if bubble != null:
		return
	bubble = Utils.spawn_child(spawn.global_position, get_parent(), bubbleScene) as InflatableBubble
	bubble.mult_growth(multiplierGrowth)
	bubble.mult_explosion_size(explosionSizeMult)

func _trigger_up():
	if bubble == null:
		return
	var dir = Vector2(cos(arrowPivot.rotation), sin(arrowPivot.rotation))
	bubble.apply_central_impulse(ShootForce * dir)
	bubble.stop_inflating()
	bubble = null
	$Cooldown.start()

func _on_enabled_change(enabled: bool):
	if bubble != null:
		bubble.queue_free()
		bubble = null

func mult_cooldown(multiplier: float):
	$Cooldown.duration = multiplier * $Cooldown.duration

func mult_growth(multiplier: float):
	multiplierGrowth += multiplier

func mult_shoot_force(multiplier: float):
	ShootForce *= multiplier

func mult_explosion_size(multiplier: float):
	explosionSizeMult += multiplier
