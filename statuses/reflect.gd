class_name ReflectStatus
extends Status

@export var block_amount := 5


func get_tooltip() -> String:
	return tooltip % [block_amount, duration]


func apply_status(target: Node) -> void:
	super.apply_status(target)
	
	var stats = null
	
	if "stats" in target and target.stats:
		stats = target.stats
	elif target.get("stats"):
		stats = target.get("stats")
		
	if stats and "block" in stats:
		stats.block += block_amount
