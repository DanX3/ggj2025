extends Weapon

var bubbleScene = preload("res://scenes/inflatable_bubble.tscn")
@onready var arrowPivot := $ArrowPivot
@onready var spawnPoints = $ArrowPivot/Arrow/SpawnPoints
var arrowDir := Vector2.RIGHT
var ShootForce = 1000
var damageBonus := 0
var spawnPointsCount = 3

func _physics_process(delta: float) -> void:
	if not enabled:
		return

	arrowDir = Vector2(Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down"))
	
	if arrowDir.length_squared() > 0.3:
		arrowPivot.rotation = atan2(arrowDir.y, arrowDir.x)
	
	if Input.is_action_pressed("trigger"):
		for spawn in spawnPoints.get_children():
			if not spawn.visible:
				continue
			var cooldown = spawn.get_child(0) as Cooldown
			if cooldown.is_ready():
				cooldown.start()
				var bubble = Utils.spawn_child(spawn.global_position, get_parent(), bubbleScene) as InflatableBubble
				bubble.stop_inflating(100)
				bubble.set_meta("damage", 1 + damageBonus)
				var dir = $ArrowPivot/Arrow/SpawnPoints.global_position.normalized()
				bubble.apply_central_impulse(ShootForce * dir)
			

func add_damage_bonus(bonus):
	damageBonus += 1

func mult_shoot_force(multiplier):
	ShootForce *= multiplier

func add_1_spawn_point():
	spawnPointsCount += 1
	spawnPoints.get_child(spawnPointsCount - 1).show()
