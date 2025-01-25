extends PowerupCard


func apply_card(player: Player):
	var damage = player.get_weapon(0).damage
	player.get_weapon(0).damage = int(1.2 * damage)
