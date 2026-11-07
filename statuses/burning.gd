class_name BurningStatus
extends Status

const damage_per_turn := 3


func get_tooltip() -> String:
	return tooltip % [damage_per_turn, duration]

func apply_status(target: Node) -> void:
	super.apply_status(target)
	
	if target.has_method("take_damage"):
		target.take_damage(damage_per_turn, 0)
	elif target.has_node("Health"):
		var health = target.get_node("Health")
		if health.has_method("take_damage"):
			health.take_damage(damage_per_turn)
