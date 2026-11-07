extends EventRoom

@onready var take_seeds_button: EventRoomButton = %TakeSeedsButton
@onready var recycle_button: EventRoomButton = %RecycleVaultButton

const SPROUT_BLESSING_CARD = preload("res://common_cards/sprout.tres")


func setup() -> void:
	take_seeds_button.event_button_callback = take_seeds
	recycle_button.event_button_callback = recycle_vault


func take_seeds() -> void:
	take_seeds_button.disabled = true
	recycle_button.disabled = true
	
	if character_stats and character_stats.get("deck"):
		character_stats.deck.add_card(SPROUT_BLESSING_CARD.duplicate())


func recycle_vault() -> void:
	take_seeds_button.disabled = true
	recycle_button.disabled = true
	
	if run_stats:
		run_stats.gold += 120
