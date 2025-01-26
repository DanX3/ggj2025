extends Weapon

var bubbleScene = preload("res://scenes/cluster_bubble.tscn")
var bubbles: Array = []
var arrowDir := Vector2.ZERO
@onready var arrowPivot := $ArrowPivot
@onready var spawn = $ArrowPivot/Arrow/SpawnPoint
var ShootForce = 600
var bubblesScale = 1.0

func _physics_process(delta: float) -> void:
	arrowDir = Vector2(Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down"))
	
	if arrowDir.length_squared() > 0.3:
		arrowPivot.rotation = atan2(arrowDir.y, arrowDir.x)

func _unhandled_input(event: InputEvent) -> void:
	if not enabled or not $Cooldown.is_ready():
		return

	if Input.is_action_just_pressed("trigger"):
		bubbles.clear()
		$Timer.start()

	if Input.is_action_just_released("trigger"):
		$Timer.stop()
		var dir = Vector2(cos(arrowPivot.rotation), sin(arrowPivot.rotation))
		for bubble in bubbles:
			if bubble != null:
				bubble.apply_central_impulse(ShootForce * dir)
		$Cooldown.start()
		bubbles.clear()


func _on_timer_timeout() -> void:
	if not Input.is_action_pressed("trigger"):
		return
	var pos = spawn.global_position + randf_range(10, 100) * Utils.rand_dir()
	var bubble = Utils.spawn_child(pos, get_parent(), bubbleScene)
	bubble.scale_size(bubblesScale)
	
	bubbles.push_back(bubble)

func spawn_time_mult(multiplier: float):
	$Timer.wait_time *= multiplier

func add_bubbles_scale(bonus):
	bubblesScale += bonus
