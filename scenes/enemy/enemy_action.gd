class_name EnemyAction
extends Node

enum Type {CONDITIONAL, CHANCE_BASED}

@export var intent: Intent
@export var sound: AudioStream
@export var type: Type
@export_range(0.0, 10.0) var chance_weight := 0.0

@onready var accumulated_weight := 0.0

var enemy: Enemy
var target: Node2D


func is_performable() -> bool:
	return false


func perform_action() -> void:
	pass


func get_modified_damage(base_damage: int) -> int:
	var modified_dmg := base_damage
	
	if enemy and enemy.has_node("ModifierHandler") or enemy and enemy.get("modifier_handler"):
		var enemy_modifiers = enemy.modifier_handler if enemy.get("modifier_handler") else enemy.get_node("ModifierHandler")
		if enemy_modifiers.has_method("get_modified_value"):
			modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_DEALT)
			
	if target and target.has_node("ModifierHandler") or target and target.get("modifier_handler"):
		var target_modifiers = target.modifier_handler if target.get("modifier_handler") else target.get_node("ModifierHandler")
		if target_modifiers.has_method("get_modified_value"):
			modified_dmg = target_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
			
	return modified_dmg


func update_intent_text() -> void:
	intent.current_text = intent.base_text
