extends Weapon

var bubbleScene = preload("res://scenes/inflatable_bubble.tscn")
@onready var arrowPivot := $ArrowPivot
@onready var spawnPoints = $ArrowPivot/Arrow/SpawnPoints
var arrowDir := Vector2.RIGHT
const ShootForce = 1000

func _physics_process(delta: float) -> void:
	if not enabled:
		return

	arrowDir = Vector2(Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down"))
	
	if arrowDir.length_squared() > 0.3:
		arrowPivot.rotation = atan2(arrowDir.y, arrowDir.x)
	
	if Input.is_action_pressed("trigger"):
		for spawn in spawnPoints.get_children():
			var cooldown = spawn.get_child(0) as Cooldown
			if cooldown.is_ready():
				cooldown.start()
				var bubble = Utils.spawn_child(spawn.global_position, self, bubbleScene) as InflatableBubble
				bubble.stop_inflating(100)
				#bubble.call_deferred("stop_inflating")
				bubble.apply_central_impulse(ShootForce * arrowDir)
			
