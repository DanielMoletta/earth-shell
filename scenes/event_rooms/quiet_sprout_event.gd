extends EventRoom

@onready var sacrifice_button: EventRoomButton = %SacrificeHpButton
@onready var ignore_button: EventRoomButton = %IgnoreButton

const SPROUT_BLESSING_CARD = preload("res://common_cards/sprout.tres")


func setup() -> void:
	sacrifice_button.event_button_callback = sacrifice_hp
	ignore_button.event_button_callback = ignore_event


func sacrifice_hp() -> void:
	sacrifice_button.disabled = true
	ignore_button.disabled = true
	
	if character_stats:
		character_stats.health -= 5
		
		if character_stats.get("deck"):
			character_stats.deck.add_card(SPROUT_BLESSING_CARD.duplicate())


func ignore_event() -> void:
	sacrifice_button.disabled = true
	ignore_button.disabled = true
