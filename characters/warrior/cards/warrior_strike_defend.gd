class_name StrikeDefendCard
extends Card

var base_damage := 3
var base_block := 3


func get_default_tooltip() -> String:
	return tooltip_text % [base_damage, base_block]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % [modified_dmg, base_block]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)

	var block_effect := BlockEffect.new()
	block_effect.amount = base_block
	block_effect.sound = sound
	
	var player := modifiers.owner if "owner" in modifiers else targets[0]
	block_effect.execute([player])
