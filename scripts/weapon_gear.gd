extends Control

@onready var baseIcon := $CanvasLayer/WeaponGear/base
@onready var rayIcon := $CanvasLayer/WeaponGear/ray
@onready var wallIcon := $CanvasLayer/WeaponGear/wall
@onready var clusterIcon := $CanvasLayer/WeaponGear/cluster
@onready var player := $AnimationPlayer
@onready var gear = $CanvasLayer/WeaponGear

var selectedWeaponIndex := 0
var isRotating := false

signal equipped(weapon_name: String)
signal unequipped()

enum Weapon {
	Base,
	Ray,
	Wall,
	Cluster
}


func equipWeapon(weapon: Weapon):
	match weapon:
		Weapon.Ray:
			rayIcon.show()
		Weapon.Wall:
			wallIcon.show()
		Weapon.Cluster:
			wallIcon.show()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("gear_left"):
		_rotate(-1)
	
	if Input.is_action_just_pressed("gear_right"):
		_rotate(+1)


func _rotate(dir: int):
	if player.is_playing() or isRotating:
		return
	
	# ignore movement if the player has only one weapon
	var visibleWeapons = 0
	for c in gear.get_children():
		if c.visible:
			visibleWeapons += 1
	if visibleWeapons == 1:
		$AnimationPlayer.play("no_change")
		return
	
	# switch to the next weapon
	var steps = 0
	var p = selectedWeaponIndex
	if dir > 0:
		while true:
			var nextWeapon = (gear.get_child(selectedWeaponIndex) as WeaponIcon).nextIcon
			selectedWeaponIndex = nextWeapon.get_index()
			steps += 1
			if nextWeapon.visible and nextWeapon.name != "wall":
				break
	else:
		while true:
			var prevWeapon = (gear.get_child(selectedWeaponIndex) as WeaponIcon).prevIcon
			selectedWeaponIndex = prevWeapon.get_index()
			steps -= 1
			if prevWeapon.visible and prevWeapon.name != "wall":
				break
	
	var angleDifference = -steps * 0.5 * PI
	var tween = get_tree().create_tween().tween_property(
		gear, "rotation", gear.rotation + angleDifference, 0.3 * abs(steps))
	isRotating = true
	tween.finished.connect(func(): 
		isRotating = false
		emit_signal("equipped", gear.get_child(selectedWeaponIndex).name))
	emit_signal("unequipped")
