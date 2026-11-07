extends Card

var base_damage := 6
var debuff_duration := 2

const EXPOSED_STATUS = preload("res://statuses/exposed.tres")


func get_default_tooltip() -> String:
	return tooltip_text % [base_damage, debuff_duration]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % [modified_dmg, debuff_duration]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	# Aplica o dano elétrico direto no alvo
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)

	# Aplica o status de debuff de block no alvo
	for target in targets:
		if target.get("status_handler"):
			var exposed := EXPOSED_STATUS.duplicate()
			exposed.duration = debuff_duration
			target.status_handler.add_status(exposed)
