extends EnemyAction

@export var damage := 2
@export var burn_duration := 3

const BURN_STATUS = preload("res://statuses/burning.tres")


func perform_action() -> void:
	if not enemy or not target:
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
			if target.get("status_handler"):
				var burn := BURN_STATUS.duplicate()
				burn.duration = burn_duration
				target.status_handler.add_status(burn)
	)
	
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)


func update_intent_text() -> void:
	var player := target as Player
	if not player:
		return
	
	var final_damage := get_modified_damage(damage)
	intent.current_text = intent.base_text % [final_damage, burn_duration]
