extends Card

var reflect_duration := 2

const REFLECT_STATUS = preload("res://statuses/reflect.tres")


func get_default_tooltip() -> String:
	return tooltip_text % reflect_duration


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text % reflect_duration


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	for target in targets:
		if target.get("status_handler"):
			var reflect := REFLECT_STATUS.duplicate()
			reflect.duration = reflect_duration
			target.status_handler.add_status(reflect)
