extends PowerupCard


func apply_card(player: Player):
	player.get_weapon(2).spawn_time_mult(0.8)
