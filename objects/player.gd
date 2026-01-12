# this is just a lazily modified version of godot's
# default character movement script for now

extends CharacterBody3D

@export var collision: CollisionShape3D
@export var sprite: AnimatedSprite3D

var last_animation = ""

var flipped_x = false
var flipped_z = false

const SPEED = 2.0
#const JUMP_VELOCITY = 4.5

func _ready() -> void:
	assert(collision != null)
	assert(sprite != null)

func set_animation(name: StringName) -> void:
	if last_animation != name:
		sprite.play(name)
		last_animation = name

func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		flipped_z = direction.normalized().z < 0
		flipped_x = direction.normalized().x < 0
		set_animation(&"bwalk" if flipped_z else &"fwalk")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		set_animation(&"bidle" if flipped_z else &"fidle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	sprite.flip_h = flipped_x

	move_and_slide()
