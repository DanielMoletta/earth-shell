class_name BattleTutorial
extends Node

const TUTORIAL_BATTLE_STATS := preload("res://battles/tier_0/tier_0_crab.tres")
const CHARACTER_STATS := preload("res://characters/warrior/warrior.tres")
const RELIC_HANDLER_SCENE := preload("res://scenes/relic_handler/relic_handler.tscn")

@onready var battle: Battle = $Battle
@onready var tutorial_ui: Control = $TutorialUI/Control
@onready var instruction_label: Label = %InstructionLabel
@onready var next_step_button: Button = %NextStep

var current_step := 0
var waiting_for_enemy_action := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if not next_step_button.pressed.is_connected(_on_next_step_pressed):
		next_step_button.pressed.connect(_on_next_step_pressed)
	
	Events.player_hand_discarded.connect(_on_player_hand_discarded_event)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended_event)
	
	var char_instance = CHARACTER_STATS.create_instance()
	battle.char_stats = char_instance
	battle.battle_stats = TUTORIAL_BATTLE_STATS
	
	var relic_handler_node = RELIC_HANDLER_SCENE.instantiate() as RelicHandler
	battle.add_child(relic_handler_node)
	battle.relics = relic_handler_node
	
	battle.start_battle()
	
	start_step(0)


func start_step(step: int) -> void:
	current_step = step
	waiting_for_enemy_action = false
	
	match current_step:
		0, 1, 2, 3:
			get_tree().paused = true
			tutorial_ui.show()
		4:
			get_tree().paused = false
			tutorial_ui.hide()
		5, 6:
			get_tree().paused = true
			tutorial_ui.show()

	match current_step:
		0:
			instruction_label.text = "BEM-VINDO AO COMBATE!\nNo canto inferior esquerdo esta a sua Energia (3/3). Cada carta gasta energia para ser jogada."
			next_step_button.text = "Proximo"
		1:
			instruction_label.text = "VEJA A INTENCAO:\nEm cima do inimigo ha um icone mostrando a acao e o dano que ele causara no proximo turno."
			next_step_button.text = "Proximo"
		2:
			instruction_label.text = "O QUE AS CARTAS FAZEM:\n- Cartas de Ataque reduzem o HP do inimigo.\n- Cartas de Defesa geram Block para absorver o dano."
			next_step_button.text = "Proximo"
		3:
			instruction_label.text = "SUA VEZ DE JOGAR:\nArraste cartas de Ataque para o inimigo ou de Defesa para si. Quando zerar sua energia, clique no botao 'Prox. Turno' no canto inferior direito."
			next_step_button.text = "Comecar a Jogar"
		4:
			pass
		5:
			instruction_label.text = "FIM DE TURNO:\nVoce encerrou seu turno! Suas cartas foram descartadas. Clique abaixo para assistir a jogada do inimigo."
			next_step_button.text = "Ver Acao do Inimigo"
		6:
			instruction_label.text = "TURNO DO INIMIGO:\nO inimigo realizou a acao dele. Um novo ciclo se inicia com novas cartas! Tutorial concluido."
			next_step_button.text = "Concluir"


func _on_next_step_pressed() -> void:
	if current_step >= 0 and current_step <= 2:
		start_step(current_step + 1)
	elif current_step == 3:
		current_step = 4
		get_tree().paused = false
		tutorial_ui.hide()
	elif current_step == 5:
		waiting_for_enemy_action = true
		get_tree().paused = false
		tutorial_ui.hide()
	elif current_step == 6:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_player_hand_discarded_event() -> void:
	if current_step == 4:
		start_step(5)


func _on_enemy_turn_ended_event() -> void:
	if waiting_for_enemy_action and current_step == 5:
		start_step(6)
