extends EventRoom

@onready var study_button: EventRoomButton = %StudyLogsButton
@onready var format_button: EventRoomButton = %FormatTerminalButton


func setup() -> void:
	study_button.event_button_callback = study_logs
	format_button.event_button_callback = format_terminal
	
	if not character_stats or not character_stats.get("deck") or character_stats.deck.cards.is_empty():
		study_button.disabled = true


func study_logs() -> void:
	study_button.disabled = true
	format_button.disabled = true
	
	if not character_stats or not character_stats.get("deck") or character_stats.deck.cards.is_empty():
		return
		
	var player_deck: CardPile = character_stats.deck as CardPile
	var draftable_pool: CardPile = character_stats.draftable_cards
	
	if not draftable_pool or draftable_pool.cards.is_empty():
		return
		
	var target_index := RNG.instance.randi_range(0, player_deck.cards.size() - 1)
	
	var random_new_card: Card = RNG.array_pick_random(draftable_pool.cards) as Card
	
	if random_new_card:
		player_deck.cards[target_index] = random_new_card.duplicate()


func format_terminal() -> void:
	study_button.disabled = true
	format_button.disabled = true
	
	if run_stats:
		run_stats.gold += 40
		
	if character_stats and character_stats.get("deck"):
		var deck_cards := character_stats.deck.cards
		for i in range(deck_cards.size() - 1, -1, -1):
			if deck_cards[i].id == "toxin":
				deck_cards.remove_at(i)
				break
