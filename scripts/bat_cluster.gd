extends Enemy

var batScene = preload("res://scenes/bat.tscn")
@export var batCount := 10

func _ready() -> void:
	for i in range(batCount):
		$Spawner.spawn()
	queue_free()
