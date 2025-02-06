extends Weapon

var bubbleScene = preload("res://scenes/cluster_bubble.tscn")
var bubbles: Array = []
var arrowDir := Vector2.ZERO
@onready var arrowPivot := $ArrowPivot
@onready var spawn = $ArrowPivot/Arrow/SpawnPoint
var ShootForce = 600
var bubblesScale = 1.0
var mouseDir := Vector2.ZERO

func _physics_process(delta: float) -> void:
	arrowDir = Vector2(Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down"))
	
	var aimDir = mouseDir if mouseDir.length_squared() > 0.0 else arrowDir
	
	if aimDir.length_squared() > 0.3:
		arrowPivot.rotation = atan2(aimDir.y, aimDir.x)

func _input(event: InputEvent) -> void:
	if not enabled or not $Cooldown.is_ready():
		return
		
	if event is InputEventMouseMotion:
		var motion = event as InputEventMouseMotion
		mouseDir = global_position.direction_to(get_global_mouse_position())
	
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
	#bubbles.clear()
	_on_timer_timeout()
	$Timer.start()

	
func _trigger_up():
	$Timer.stop()
	var dir = Vector2(cos(arrowPivot.rotation), sin(arrowPivot.rotation))
	print(bubbles.size())
	for bubble in bubbles:
		if bubble != null:
			bubble.apply_central_impulse(ShootForce * dir)
	$Cooldown.start()
	bubbles.clear()


func _on_timer_timeout() -> void:
	if not Input.is_action_pressed("trigger"):
		$Timer.stop()
		return
	
	if not $BubbleSpawnCooldown.is_ready():
		return
	
	$BubbleSpawnCooldown.start()
	print("Spawned bubble")
	var pos = spawn.global_position + randf_range(10, 50) * Utils.rand_dir()
	var bubble = Utils.spawn_child(pos, get_parent(), bubbleScene)
	bubble.scale_size(bubblesScale)
	bubbles.push_back(bubble)

func spawn_time_mult(multiplier: float):
	$Timer.wait_time *= multiplier
	$BubbleSpawnCooldown.duration *= multiplier

func add_bubbles_scale(bonus):
	bubblesScale += bonus
