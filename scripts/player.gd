extends Node2D


@onready var weaponGear := $WeaponGear
var weapon: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_weapon_gear_unequipped() -> void:
	if weapon != null:
		weapon.queue_free()
		weapon = null


func _on_weapon_gear_equipped(weapon_name: String) -> void:
	assert(weapon == null)
	match weapon_name:
		"base":
			pass
