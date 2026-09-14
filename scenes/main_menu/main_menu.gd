extends Control

const CHAR_SELECTOR_SCENE := preload("res://scenes/ui/character_selector.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = %Continue

func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_new_run_pressed() -> void:
	SceneManager.transition_to(CHAR_SELECTOR_SCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_timer_timeout() -> void:
	animation_player.play("drop")
