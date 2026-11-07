extends Card

var base_damage := 4
var burn_duration_to_apply := 2

const BURN_STATUS = preload("res://statuses/burning.tres")


func get_default_tooltip() -> String:
	return tooltip_text % [base_damage, burn_duration_to_apply]


func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % [modified_dmg, burn_duration_to_apply]


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)

	# Aplica o status de queimadura flexível em cada alvo
	for target in targets:
		if target.get("status_handler"):
			var burn := BURN_STATUS.duplicate()
			burn.duration = burn_duration_to_apply # Flexível para qualquer aplicação
			target.status_handler.add_status(burn)
