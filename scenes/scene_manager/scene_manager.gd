extends CanvasLayer

signal transitioned_in()
signal transitioned_out()

var current_scene: Node
var is_transitioning: bool = false 

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var margin_container: MarginContainer = $MarginContainer

@export_group("Room Scenes")
@export var monster_room: PackedScene
@export var treasure_room: PackedScene
@export var campfire_room: PackedScene
@export var shop_room: PackedScene
@export var boss_room: PackedScene

func _ready() -> void:
	current_scene = get_tree().current_scene
	animation_player.play("out")

func set_current_scene(value: Node) -> void:
	if current_scene == value:
		return
		
	if current_scene:
		current_scene.queue_free()
		
	current_scene = value
	var root: Window = get_tree().get_root()
	root.add_child(current_scene)
	get_tree().current_scene = current_scene 

func transition_in() -> void:
	animation_player.play("in")

func transition_out() -> void:
	create_tween().tween_property(margin_container, "scale", Vector2.ZERO, 0.3)
	animation_player.play("out")

func transition_to(scene_input) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	
	transition_in()
	await transitioned_in

	var scene_to_load: PackedScene
	
	# Determine which scene to load based on the input type
	if scene_input is Room:
		match scene_input.type:
			Room.Type.MONSTER:
				scene_to_load = monster_room
			Room.Type.TREASURE:
				scene_to_load = treasure_room
			Room.Type.SHOP:
				scene_to_load = shop_room
			Room.Type.CAMPFIRE:
				scene_to_load = campfire_room
			Room.Type.BOSS:
				scene_to_load = boss_room
			_:
				print("Error: Room type is NOT_ASSIGNED or invalid!")
				is_transitioning = false
				return
				
	# If a PackedScene object is passed directly
	elif scene_input is PackedScene:
		scene_to_load = scene_input
		
	# If a String file path is passed
	elif scene_input is String:
		scene_to_load = load(scene_input)
		
	else:
		print("Error: Invalid input passed to SceneManager.")
		is_transitioning = false
		return

	# Catch if the export variable was left empty in the Inspector
	if scene_to_load == null:
		print("Error: Scene missing! Did you assign it in the SceneManager Inspector?")
		is_transitioning = false
		return

	var new_scene = scene_to_load.instantiate()
	var root: Window = get_tree().get_root()
	
	if current_scene:
		current_scene.queue_free()
		
	root.add_child(new_scene)
	
	current_scene = new_scene
	get_tree().current_scene = new_scene

	if new_scene.has_method("load_scene"):
		new_scene.load_scene()
		await new_scene.loaded

	transition_out()
	await transitioned_out

	if new_scene.has_method("activate"):
		new_scene.activate()
		
	is_transitioning = false


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "in":
		animation_player.play("text_pulse")
		transitioned_in.emit()
	elif anim_name == "out":
		transitioned_out.emit()
