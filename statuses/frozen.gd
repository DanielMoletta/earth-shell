class_name FrozenStatus
extends Status

const REDUCTION_PERCENT := 0.25


func get_tooltip() -> String:
	return tooltip % duration


func initialize_status(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg dealt modifier on %s" % target)

	var frozen_modifier_value := dmg_dealt_modifier.get_value("frozen")

	if not frozen_modifier_value:
		frozen_modifier_value = ModifierValue.create_new_modifier("frozen", ModifierValue.Type.PERCENT_BASED)
		
		# Exemplo de cálculo de redução utilizando ceili para arredondar o impacto da penalidade
		var calculated_reduction := ceili(100.0 * REDUCTION_PERCENT) / 100.0
		frozen_modifier_value.percent_value = -calculated_reduction
		
		dmg_dealt_modifier.add_new_value(frozen_modifier_value)
	
	if not status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(dmg_dealt_modifier))


func _on_status_changed(dmg_dealt_modifier: Modifier) -> void:
	if duration <= 0 and dmg_dealt_modifier:
		dmg_dealt_modifier.remove_value("frozen")
