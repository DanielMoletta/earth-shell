extends EventRoom

@onready var cleanup_button: EventRoomButton = %CleanUpButton
@onready var scavenge_button: EventRoomButton = %ScavengeButton

const TOXIN_CARD = preload("res://common_cards/toxin.tres")


func setup() -> void:
	cleanup_button.event_button_callback = clean_up_barrel
	scavenge_button.event_button_callback = scavenge_barrel


func clean_up_barrel() -> void:
	cleanup_button.disabled = true
	scavenge_button.disabled = true
	
	if character_stats:
		var hp_reduction := ceili(character_stats.max_health * 0.1)
		character_stats.max_health -= hp_reduction
		if character_stats.health > character_stats.max_health:
			character_stats.health = character_stats.max_health
			
	if run_stats:
		run_stats.gold += 300


func scavenge_barrel() -> void:
	cleanup_button.disabled = true
	scavenge_button.disabled = true
	
	if run_stats:
		run_stats.gold += 80
		
	if character_stats and character_stats.get("deck"):
		character_stats.deck.add_card(TOXIN_CARD.duplicate())
