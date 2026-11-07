extends Card


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var card_draw_effect := CardDrawEffect.new()
	card_draw_effect.cards_to_draw = 2
	card_draw_effect.execute(targets)
