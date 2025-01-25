class_name Weapon extends Node2D

var enabled = false

func _ready() -> void:
	set_enabled(false)

func set_enabled(enabled: bool):
	_on_enabled_change(enabled)
	self.enabled = enabled
	set_process(enabled)
	set_physics_process(enabled)
	if enabled:
		show()
	else:
		hide()


func _on_enabled_change(enabled: bool):
	pass
