extends CharacterBody2D

@export
var speed = 300.0
@export
var jump_force = -300.0

@export
var fall_gravity: Vector2 = Vector2(0, 1200);

@export
var acceleration = 0.85

@export
var deceleration = 0.95

@export
var spawn: Node2D


@export
var death_screen: AnimatedSprite2D


var speed_modifier = 1
var accel_modifer = 1
var spawn_point: Vector2
@onready
var anim = $AnimatedSprite2D

func _ready():
	spawn_point = spawn.global_position
	add_to_group("player")
	anim.play("idle")
		

func _physics_process(delta: float) -> void:
	var gravity = get_gravity()
	if not is_on_floor():
		gravity = lerp(gravity, fall_gravity, 0.05)
		velocity += gravity * delta
		speed_modifier = 0.75
		accel_modifer = 0.9
	else:
		speed_modifier = 1
		accel_modifer = 1
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 0.5*velocity.y+ jump_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
		
	if direction:
		velocity.x = lerp(velocity.x, speed*speed_modifier*direction, acceleration*accel_modifer)
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration)

	move_and_slide()
	
	if direction != 0:
		anim.flip_h = direction < 0
		if anim.animation != "mv":
			anim.play("mv")
	else:
		if anim.animation != "idle":
			anim.play("idle")

func die():
	print("die")
	set_physics_process(false)
	death_screen.play("die")
	await death_screen.animation_finished
	respawn()

func respawn():
	global_position = spawn_point
	death_screen.play("respawn")
	set_physics_process(true)
	await death_screen.animation_finished

func _on_hazard_entered(_body: Node2D) -> void:
	die()

func set_spawn(pos: Vector2):
	spawn_point = pos
