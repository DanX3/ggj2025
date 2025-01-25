extends Node3D

var spawnee := preload("res://scenes/enemy.tscn")
@export var timeout: float = 5.0


func _ready() -> void:
	$Timer.wait_time = randf_range(3.0, timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	Utils.spawn_child_3d(global_position, self, spawnee)
