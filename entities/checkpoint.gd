extends Area2D

@export var end: bool = false
@export var stage_manager: StageManager

signal checkpoint_reached(new_spawn_point: Vector2)

func _ready() -> void:
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if end:
			stage_manager.to_next_scene()
		var spawn_point: Vector2
		spawn_point = global_position
		checkpoint_reached.emit(spawn_point)
		print("Checkpoint reached at ", spawn_point)
		$CollisionShape2D.disabled = true
