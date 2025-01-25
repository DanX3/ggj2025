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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
		_rotate(+1)
	
	if Input.is_action_just_pressed("gear_right"):
		_rotate(-1)


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
	var newIndex = selectedWeaponIndex
	var stepDiff = 0
	if dir > 0:
		for i in range(1, 3):
			newIndex = (selectedWeaponIndex + i) % 4
			if gear.get_child(newIndex).visible:
				stepDiff = selectedWeaponIndex - (newIndex if newIndex > 0 else 4)
				print("selected  %d - newIndex %d = %d" % [selectedWeaponIndex, newIndex, selectedWeaponIndex - newIndex])
				break
	else:
		for i in range(-1, -3, -1):
			newIndex = selectedWeaponIndex + i
			var positiveIndex = newIndex if newIndex >= 0 else newIndex + 4
			if gear.get_child(positiveIndex).visible:
				stepDiff = selectedWeaponIndex - newIndex
				break
	print_debug(stepDiff)
	var angleDifference = 0.5 * PI * stepDiff
	var tween = get_tree().create_tween().tween_property(
		gear, "rotation", gear.rotation + angleDifference, 0.3 * abs(stepDiff))
	isRotating = true
	tween.finished.connect(func(): 
		isRotating = false
		emit_signal("equipped", gear.get_child(selectedWeaponIndex).name))
	selectedWeaponIndex = (newIndex + 4) % 4 
	emit_signal("unequipped")
	
