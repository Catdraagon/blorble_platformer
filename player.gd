extends CharacterBody2D

var speed = 400
var fall_gravity = 2000
var jump_gravity = 900
var jump_force = -500
var jump_boost_max = 0.5
var jump_boost = -25
var jump_time = 0.0
var is_jumping = false

func _physics_process(delta):
	var direction = 0	
	if Input.is_action_pressed("ui_right"):
		direction += 1
	if Input.is_action_pressed("ui_left"):
		direction -= 1
	velocity.x = direction * speed
	
	var gravity = 0
	if velocity.y <= 0:
		gravity = jump_gravity
	else:
		gravity = fall_gravity
		
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jump_time = 0.0
		is_jumping = false
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		jump_time = 0.0
		
	if is_jumping and Input.is_action_pressed("ui_up"):
		jump_time += delta
		if jump_time < jump_boost_max:
			velocity.y += jump_boost
	
	move_and_slide()
