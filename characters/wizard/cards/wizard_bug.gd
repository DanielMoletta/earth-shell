extends Card

var base_heal := 3


func get_default_tooltip() -> String:
	return tooltip_text % base_heal


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % base_heal


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	for target in targets:
		if target.get("stats") and target.stats.has_method("heal"):
			target.stats.heal(base_heal)
		elif target.has_method("heal"):
			target.heal(base_heal)
