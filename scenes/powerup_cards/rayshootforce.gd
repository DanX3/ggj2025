extends PowerupCard


func apply_card(player: Player):
	player.get_weapon(1).mult_shoot_force(1.2)
