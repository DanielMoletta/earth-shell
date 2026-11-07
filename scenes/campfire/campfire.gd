class_name Campfire
extends Control

@export var char_stats: CharacterStats

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rest_button: Button = %RestButton
@onready var lore_label: Label = %LoreLabel

const CAMPFIRE_LORE: Array[String] = [
	"O calor das chamas afasta temporariamente a nevoa toxica que consome a superficie.",
	"Antigas corporacoes transformaram o solo em cinzas; a natureza agora luta para retomar o que e seu.",
	"O som de engrenagens enferrujadas ecoa ao longe, lembrando os horrores da Grande Poluicao.",
	"Fios de cobre e cascas de asrvores fundem-se nos restos abandonados deste bioma.",
	"Cada respiracao profunda traz o gosto amargo do ar filtrado por milagre.",
	"Restos de tecnologia obsoleta servem de lenha para aquecer o que restou da humanidade.",
	"Dizem que sementes puras ainda dormem em cofres subterraneos esquecidos pelo tempo.",
	"A fauna mutante observa da escuridao, atraida pelo brilho seguro da fogueira.",
	"O solo acido corroi o metal, mas a persistencia da vida verde insiste em brotar.",
	"Neste mundo de escombros, o fogo e tanto um refugio quanto um farol para perigos."
]

static var last_index: int = -1


func _ready() -> void:
	if not lore_label or CAMPFIRE_LORE.is_empty():
		return
		
	var available_indices: Array[int] = []
	for i in range(CAMPFIRE_LORE.size()):
		if i != last_index:
			available_indices.append(i)
	
	# Caso de segurança extrema
	if available_indices.is_empty():
		available_indices.append(0)
		
	available_indices.shuffle()
	
	var new_index := available_indices[0]
	last_index = new_index
	lore_label.text = CAMPFIRE_LORE[new_index]


func _on_rest_button_pressed() -> void:
	rest_button.disabled = true
	char_stats.heal(ceili(char_stats.max_health * 0.3))
	animation_player.play("fade_out")


func _on_fade_out_finished() -> void:
	Events.campfire_exited.emit()
