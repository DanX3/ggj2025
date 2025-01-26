extends PowerupCard


func apply_card(player: Player):
	player.get_weapon(2).add_bubbles_scale(0.2)
