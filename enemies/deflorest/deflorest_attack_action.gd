extends EnemyAction

@export var damage := 6
@export var debuff_duration := 2

const FRACTURED_STATUS = preload("res://statuses/exposed.tres")


func perform_action() -> void:
	if not enemy or not target:
		Events.enemy_action_completed.emit(enemy)
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	var target_array: Array[Node] = [target]
	
	damage_effect.amount = get_modified_damage(damage)
	damage_effect.sound = sound
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	
	tween.tween_callback(
		func():
			if target and is_instance_valid(target):
				var status_handler = target.get("status_handler")
				if status_handler and FRACTURED_STATUS:
					var fractured := FRACTURED_STATUS.duplicate() as Status
					if fractured:
						fractured.duration = debuff_duration
						status_handler.add_status(fractured)
	)
	
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)


func update_intent_text() -> void:
	if not target or not intent:
		return
	
	var final_damage := get_modified_damage(damage)
	intent.current_text = intent.base_text % [final_damage, debuff_duration]
