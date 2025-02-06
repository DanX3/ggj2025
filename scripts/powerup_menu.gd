extends Control

signal done

@export var powerups : Array[PackedScene]
@onready var menu = $HBoxContainer

func show_powerups():
	var ids = range(powerups.size())
	ids.shuffle()
	for i in range(3):
		var card = powerups[ids[i]].instantiate() as PowerupCard
		card.chosen.connect(_chosen_card.bind(i))
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


func _chosen_card(id: int) -> void:
	print("chosen card " + str(id))
	var player = get_tree().get_first_node_in_group("player")
	menu.get_child(id).apply_card(player)
	for i in range(3):
		if i == id:
			menu.get_child(i).animate_chosen()
		else:
			menu.get_child(i).animate_discard()
	$AnimationPlayer.play("done")
