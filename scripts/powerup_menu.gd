extends Control

signal done

@export var powerups : Array[PackedScene]
@onready var menu = $HBoxContainer

func show_powerups():
	var ids = range(powerups.size())
	ids.shuffle()
	for i in range(3):
		print(ids[i])
		var card = powerups[ids[i]].instantiate()
		menu.add_child(card)

func _unhandled_input(event: InputEvent) -> void:
	if menu.get_child_count() == 0:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if Input.is_action_just_pressed("card0"):
		menu.get_child(0).apply_card(player)
		_clear_powerups()
	if Input.is_action_just_pressed("card1"):
		menu.get_child(1).apply_card(player)
		_clear_powerups()
	if Input.is_action_just_pressed("card2"):
		menu.get_child(2).apply_card(player)
		_clear_powerups()
		
func _clear_powerups():
	for child in menu.get_children():
		menu.remove_child(child)
		child.queue_free()
	$AnimationPlayer.play("done")
	emit_signal("done")
