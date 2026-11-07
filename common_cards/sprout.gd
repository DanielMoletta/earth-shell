extends Card

var heal_amount := 5
var block_amount := 5


func get_default_tooltip() -> String:
	return tooltip_text % [heal_amount, block_amount]


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % [heal_amount, block_amount]


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	for target in targets:
		# Aplica a cura no alvo (jogador) de forma segura
		var stats = null
		
		if "stats" in target and target.stats:
			stats = target.stats
		elif target.get("stats"):
			stats = target.get("stats")
			
		if stats and stats.has_method("heal"):
			stats.heal(heal_amount)
		
		# Aplica o escudo (block)
		var block_effect := BlockEffect.new()
		block_effect.amount = block_amount
		block_effect.sound = sound
		block_effect.execute([target])
