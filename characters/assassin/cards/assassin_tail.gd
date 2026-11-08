extends Card

var base_damage := 12
var hp_cost := 5


func get_default_tooltip() -> String:
	return tooltip_text % [base_damage, hp_cost]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % [modified_dmg, hp_cost]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)

	var player := targets[0].get_tree().get_first_node_in_group("player") if not targets.is_empty() else null
	
	if player and "stats" in player and player.stats:
		player.stats.take_damage(hp_cost)
