extends Node2D

@onready var weaponGear := $WeaponGear
var weapon: Weapon = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_weapon_gear_equipped("base")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_weapon_gear_unequipped() -> void:
	if weapon != null:
		weapon.set_enabled(false)
		weapon = null


func _on_weapon_gear_equipped(weapon_name: String) -> void:
	pass
	#assert(weapon == null)
	#match weapon_name:
		#"base":
			#weapon = $WeaponBase
		#"ray":
			#weapon = $WeaponRay
	
	#weapon.set_enabled(true)
