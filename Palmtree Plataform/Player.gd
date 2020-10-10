extends KinematicBody2D
const TARGET_FPS = 60
const ACCELERATION = 8
const MAX_SPEED = 64
const FRICTION = 10
const AIR_RESISTANCE = 1
const GRAVITY = 4
const JUMP_FORCE = 140

var motion = Vector2.ZERO

onready var sprite = $Sprite #getting acess to sprite
onready var animationPlayer = $AnimationPlayer


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") #1 if we are pressing right -1 if left 0 if none
	
	if x_input !=0:
		animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta * TARGET_FPS
		motion.x =clamp(motion.x, -MAX_SPEED, MAX_SPEED) #preveting motion to to get out of bounds
		sprite.flip_h = x_input <0
	else:
		animationPlayer.play("Stand")
		
	motion.y += GRAVITY * delta * TARGET_FPS #applying gravity
	
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION * delta) #approaching motion value to 0 by friction
	
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else: #is in air
		animationPlayer.play("Jump")
		
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2: # checking if we are moving up quickly still
			motion.y = -JUMP_FORCE/2 #slowing the player down if we release the jump key
			
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta) 
	motion = move_and_slide(motion, Vector2.UP) #setting motion as the parameter to move
