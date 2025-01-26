extends PowerupCard

func apply_card(player: Player):
	player.get_weapon(1).add_damage_bonus(1)
