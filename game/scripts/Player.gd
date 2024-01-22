extends CharacterBody2D

@export var SPEED = 500.0
@export var JUMP_VELOCITY = -400.0
@export var dash_factor = 2.0
@export var max_jumps = 2
@export var spell_duration = 150

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Double jump counter
var jumps = 0
var instant_speed = SPEED
var spell_cast = 0
var is_spell_casting = false

func _physics_process(delta):
	# Reset spells effect is aplicable
	if spell_cast == spell_duration:
		spell_cast = 0
		is_spell_casting=false
		instant_speed = SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		jumps = 0
	
	if Input.is_action_just_pressed("jump") and jumps < max_jumps:
		jumps+=1
		velocity.y = JUMP_VELOCITY + jumps * 10

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if is_spell_casting:
		spell_cast+=1
	
	if Input.is_action_just_pressed("spell1") and !is_spell_casting:
		is_spell_casting=true
		instant_speed *= dash_factor
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * instant_speed
	else:
		velocity.x = move_toward(velocity.x, 0, instant_speed)

	print(instant_speed, " ", spell_cast, " ", is_spell_casting, " ", jumps)

	move_and_slide()
