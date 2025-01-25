class_name Weapon extends Node2D

var enabled = false

func _ready() -> void:
	set_enabled(false)

func set_enabled(enabled: bool):
	self.enabled = enabled
	set_process(enabled)
	set_physics_process(enabled)
	if enabled:
		show()
	else:
		hide()
