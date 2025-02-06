class_name Player extends Node2D

signal game_over
signal damaged

@onready var weaponGear := $WeaponGear
@onready var lifeBar = $LifeBar
var weapon: Weapon = null
var max_life = 100
@onready var life = max_life
@onready var alive = true

@export var spriteFront: Sprite2D
@export var spriteBack: Sprite2D
@export var spriteLeft: Sprite2D
@export var spriteRight: Sprite2D

var mouseDir := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WeaponBase.set_enabled(false)
	$WeaponRay.set_enabled(false)
	$WeaponCluster.set_enabled(false)
	_on_weapon_gear_equipped("base")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var motion = event as InputEventMouseMotion
		mouseDir = global_position.direction_to(get_global_mouse_position())

func _process(delta: float) -> void:
	var arrowDir = Vector2(Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down"))
	
	var aimDir = mouseDir if mouseDir.length_squared() > 0.0 else arrowDir
	
	if aimDir.length_squared() < 0.8:
		return
		
	for s in $Sprites.get_children():
		if s is Sprite2D:
			s.hide()
	
	if aimDir.x > 0.5:
		spriteRight.show()
	elif aimDir.x < -0.5:
		spriteLeft.show()
	elif aimDir.y > 0.5:
		spriteBack.show()
	elif aimDir.y < -0.5:
		spriteFront.show()

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
	emit_signal("damaged")
	$AnimationPlayer.play("damaged")
	if life <= 0 and alive:
		alive = false
		emit_signal("game_over")

func get_weapon(index: int) -> Weapon:
	match index:
		0: return $WeaponBase
		1: return $WeaponRay
		2: return $WeaponCluster
	
	assert(false)
	return null

func heal():
	life = max_life
	lifeBar.value = max_life

func increase_max_life(amount: int):
	max_life += amount
	life = max_life
	lifeBar.value = max_life
