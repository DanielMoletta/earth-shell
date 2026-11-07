extends EventRoom

@onready var extract_button: EventRoomButton = %ExtractCoreButton
@onready var disable_button: EventRoomButton = %DisableCoreButton


func setup() -> void:
	extract_button.event_button_callback = extract_core
	disable_button.event_button_callback = disable_core


func extract_core() -> void:
	extract_button.disabled = true
	disable_button.disabled = true
	
	if character_stats:
		character_stats.max_health -= 10
		
		if character_stats.health > character_stats.max_health:
			character_stats.health = character_stats.max_health
			
		if "max_mana" in character_stats:
			character_stats.max_mana += 1


func disable_core() -> void:
	extract_button.disabled = true
	disable_button.disabled = true
	
	if run_stats:
		run_stats.gold += 100
