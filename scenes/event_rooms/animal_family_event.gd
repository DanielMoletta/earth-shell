extends EventRoom

@onready var blue_button: EventRoomButton = %BlueButton
@onready var red_button: EventRoomButton = %RedButton


func setup() -> void:
	
	blue_button.event_button_callback = press_blue
	red_button.event_button_callback = press_red


func press_blue() -> void:
	blue_button.disabled = true
	
	character_stats.heal(ceili(character_stats.max_health * 0.2))


func press_red() -> void:
	red_button.disabled = true
	
	character_stats.max_health += 2
