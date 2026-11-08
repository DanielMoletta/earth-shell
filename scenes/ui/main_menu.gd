extends Control

const CHAR_SELECTOR_SCENE := preload("res://scenes/ui/character_selector.tscn")
const RUN_SCENE = preload("res://scenes/run/run.tscn")
const BATTLE_TUTORIAL_SCENE := preload("res://scenes/tutorial/battle_tutorial.tscn")

@export var run_startup: RunStartup

@onready var continue_button: Button = %Continue
@onready var tutorial_button: Button = %Tutorial


func _ready() -> void:
	get_tree().paused = false
	continue_button.disabled = SaveGame.load_data() == null


func _on_continue_pressed() -> void:
	run_startup.type = RunStartup.Type.CONTINUED_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_packed(CHAR_SELECTOR_SCENE)


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_packed(BATTLE_TUTORIAL_SCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()
