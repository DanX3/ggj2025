class_name Player extends Node2D

signal game_over

@onready var weaponGear := $WeaponGear
@onready var lifeBar = $LifeBar
var weapon: Weapon = null
var max_life = 100
@onready var life = max_life
@onready var alive = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WeaponBase.set_enabled(false)
	$WeaponRay.set_enabled(false)
	$WeaponCluster.set_enabled(false)
	_on_weapon_gear_equipped("base")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_weapon_gear_unequipped() -> void:
	if weapon != null:
		weapon.set_enabled(false)
		weapon = null


func _on_weapon_gear_equipped(weapon_name: String) -> void:
	assert(weapon == null)
	match weapon_name:
		"base":
			weapon = $WeaponBase
		"ray":
			weapon = $WeaponRay
		"cluster":
			weapon = $WeaponCluster
	
	weapon.set_enabled(true)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if not (body is Enemy):
		return
		
	life -= (body as Enemy).damage
	lifeBar.value = life
	body.queue_free()
	
	if life <= 0 and alive:
		alive = false
		emit_signal("game_over")

func get_weapon(index: int) -> Weapon:
	match index:
		0: return $WeaponBase
		1: return $WeaponRay
	
	assert(false)
	return null

func heal():
	life = max_life
	lifeBar.value = max_life

func increase_max_life(amount: int):
	max_life += amount
	life = max_life
	lifeBar.value = max_life
