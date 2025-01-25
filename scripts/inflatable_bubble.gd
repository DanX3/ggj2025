class_name InflatableBubble extends RigidBody2D

@onready var spawnTime = Time.get_ticks_msec()
const InitialSize := Vector2(303, 303)
const GrowPerSec = 10000
var canGrow = true
var size = 100
var wasMoving = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_size(size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if canGrow:
		size += GrowPerSec * delta
		_set_size(size)
	elif linear_velocity.length_squared() < 10.0 and wasMoving:
		queue_free()
	wasMoving = linear_velocity.length_squared() > 10.0

func _set_size(size: float):
	var circle = $CollisionShape2D.shape as CircleShape2D
	circle.radius = sqrt(size / PI)
	var scale = (2.0 * circle.radius) / InitialSize.x
	$Sprite2D.scale = Vector2(scale, scale)

func stop_inflating(size := -1):
	canGrow = false
	

func _on_body_entered(body: Node) -> void:
	var explosionCircle = $ExplosionArea/CollisionShape2D.shape as CircleShape2D
	explosionCircle.radius = 1.25 * ($CollisionShape2D.shape as CircleShape2D).radius
	$Explosion.scale = 1.25 * $Sprite2D.scale
	$AnimationPlayer.play("explode")


func _on_explosion_area_body_entered(body: Node2D) -> void:
	if not (body is Enemy):
		return
	
	var enemy = body as Enemy
	enemy.take_damage(10)
	
