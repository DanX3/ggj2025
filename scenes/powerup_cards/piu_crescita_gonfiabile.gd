extends PowerupCard


func apply_card(player: Player):
	player.get_weapon(0).mult_growth(1.2)
