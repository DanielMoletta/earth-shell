extends Card

var base_damage := 5
var block_per_enemy := 3


func get_default_tooltip() -> String:
	return tooltip_text % [base_damage, block_per_enemy]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % [modified_dmg, block_per_enemy]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)

	var hit_count := targets.size()

	if hit_count > 0:
		var block_effect := BlockEffect.new()
		block_effect.amount = block_per_enemy * hit_count
		block_effect.sound = sound
		
		var player := targets[0].get_tree().get_first_node_in_group("player") if not targets.is_empty() else null
		
		if player:
			block_effect.execute([player])
