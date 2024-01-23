extends CharacterBody2D

@export var SPEED : float = 150.0
@export var GRAVITY : float = 981
@export var JUMP_FORCE : float = 250.0
@export var DASH_FACTOR : float = 1.5
@export var SPELL_DURATION : float = .5
@export var JUMPS_AMOUNT : int = 2

@onready var _animation_controller = $Sprite
@onready var _JumpSfx = $JumpSfx
@onready var _DashSfx = $DashSfx

# Reset de player position when fired
func game_over():
	position.x = 0
	position.y = 0
	
var jumps_counter = 0
var is_spell_casting = false
var spell_delta = 0

func _physics_process(delta):
	
	var current_speed = SPEED
	
	# Reset counter
	if is_on_floor():
		jumps_counter = 0
	
	# Aply gravity
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
	# use spells
	if Input.is_action_just_pressed("spell1") and !is_spell_casting:
		is_spell_casting = true
		_DashSfx.play()
	
	if is_spell_casting:
		spell_delta+=delta
		
	if spell_delta >= SPELL_DURATION:
		is_spell_casting = false
		spell_delta = 0
		
	if is_spell_casting:
		current_speed = SPEED * DASH_FACTOR
	
	# Get mouvement
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	if Input.is_action_just_pressed("jump") and jumps_counter < JUMPS_AMOUNT:
		velocity.y -= JUMP_FORCE
		_JumpSfx.play()
	
	# Control animations
	if Input.is_action_just_pressed("move_left"):
		_animation_controller.flip_h = true
		_animation_controller.play("walk")
	elif Input.is_action_just_pressed("move_right"):
		_animation_controller.flip_h = false
		_animation_controller.play("walk")
	elif Input.is_action_just_pressed("jump") and jumps_counter < JUMPS_AMOUNT:
		jumps_counter+=1
		_animation_controller.play("jump")
	else:
		_animation_controller.play("idle")
		
	# Run the movements
	move_and_slide()
