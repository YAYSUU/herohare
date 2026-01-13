# this is just a lazily modified version of godot's
# default character movement script for now

extends CharacterBody3D

@export var collision: CollisionShape3D
@export var sprite: AnimatedSprite3D

var last_animation = ""

var flipped_x = false
var flipped_z = false
var runnin = false

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
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("game_left", "game_right", "game_up", "game_down") # ooooh how i hate vectors!
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		runnin = Input.is_action_pressed("game_cancel")
		velocity.x = direction.x * (SPEED*2.5 if runnin else SPEED*1.5) # gotta go SLIGHTLY FESTER such that MOVING FEELS NOT SLUGGISH!
		velocity.z = direction.z * (SPEED*2 if runnin else SPEED) # gotta go FEST!
		if (velocity.z != 0): # This sucks don't change it
			flipped_z = velocity.z < 0
		if (velocity.x != 0):
			flipped_x = velocity.x < 0
		set_animation(&"bwalk" if flipped_z else &"fwalk")
	else:
		set_animation(&"bidle" if flipped_z else &"fidle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	sprite.flip_h = flipped_x

	move_and_slide()
