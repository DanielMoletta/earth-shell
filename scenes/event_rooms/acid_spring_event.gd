extends EventRoom

@onready var drink_button: EventRoomButton = %DrinkButton
@onready var purify_button: EventRoomButton = %PurifyButton

const PURIFY_COST := 60


func setup() -> void:
	drink_button.event_button_callback = drink_from_spring
	purify_button.event_button_callback = purify_spring
	
	if run_stats:
		purify_button.disabled = run_stats.gold < PURIFY_COST


func drink_from_spring() -> void:
	drink_button.disabled = true
	purify_button.disabled = true
	
	if not character_stats:
		return
		
	var roll := RNG.instance.randf()
	if roll < 0.5:
		character_stats.health = character_stats.max_health
	else:
		character_stats.health = maxi(1, character_stats.health - 8)


func purify_spring() -> void:
	drink_button.disabled = true
	purify_button.disabled = true
	
	if run_stats:
		run_stats.gold -= PURIFY_COST
		
	if character_stats:
		var heal_amount := ceili(character_stats.max_health * 0.25)
		character_stats.heal(heal_amount)
