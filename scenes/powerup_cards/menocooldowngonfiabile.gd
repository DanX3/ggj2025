extends PowerupCard


func apply_card(player: Player):
	var weapon = player.get_weapon(0)
	weapon.mult_cooldown(0.9)
