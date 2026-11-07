extends Card


func get_default_tooltip() -> String:
	return tooltip_text


func get_updated_tooltip(_player_modifiers: ModifierHandler, _enemy_modifiers: ModifierHandler) -> String:
	return tooltip_text


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	for target in targets:
		if not target.get("status_handler"):
			continue
		
		var status_handler = target.status_handler
		
		for child in status_handler.get_children():
			if child.get("status") and child.status is Status:
				var status: Status = child.status
				
				if status.stack_type == Status.StackType.INTENSITY:
					status.stacks *= 2
				elif status.stack_type == Status.StackType.DURATION:
					status.duration *= 2
