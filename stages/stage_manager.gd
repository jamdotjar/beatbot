class_name StageManager
extends Node

@export var next_scene: PackedScene
@export var menu_scene: PackedScene

@export var fade_in_anim: String = "scene_in"
@export var fade_out_anim: String = "scene_out"

@export var anim: AnimatedSprite2D

func _ready():
	anim.play(fade_in_anim)

func to_next_scene():
	_transition_to_scene(next_scene.resource_path)

func to_menu():
	_transition_to_scene(menu_scene.resource_path)

func _transition_to_scene(scene_path: String):
	set_physics_process(false)
	if not scene_path or not ResourceLoader.exists(scene_path):
		push_error("Invalid scene path: %s" % scene_path)
		return

	# Play fade out animation, then switch scene
	
	anim.play(fade_out_anim)
	await anim.animation_finished

	get_tree().change_scene_to_file(scene_path)


func _on_level_end_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
