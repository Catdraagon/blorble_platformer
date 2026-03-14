extends CharacterBody2D

var fall_gravity = 3000
var jump_gravity = 500
var jump_force = -700
var jump_slowdown = 0.5

var accl = 8000
var sprint_accl = 40000
var friction = 4000
var max_speed = 600
var sprint_max_speed = 1000
var brake = 70000
var sprint_brake = 20000

func _physics_process(delta):
	var is_stop = false
	var current_accl = 0
	var direction = 0
	if velocity.x == 0:
		if Input.is_action_pressed("ui_right"):
			current_accl = accl
		elif Input.is_action_pressed("ui_left"):
			current_accl = -accl
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_right"):
			current_accl = sprint_accl
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_left"):
			current_accl = -sprint_accl
	if velocity.x > 0:
		if Input.is_action_pressed("ui_right"):
			current_accl = accl
		elif Input.is_action_pressed("ui_left"):
			#current_accl = -brake
			is_stop = true
			direction = -1
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_right"):
			current_accl = sprint_accl
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_left"):
			current_accl = -sprint_brake
		else:
			current_accl = -friction
	if velocity.x < 0:
		if Input.is_action_pressed("ui_right"):
			#current_accl = brake
			is_stop = true
			direction = 1
		elif Input.is_action_pressed("ui_left"):
			current_accl = -accl
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_right"):
			current_accl = sprint_brake
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_left"):
			current_accl = -sprint_accl
		else:
			current_accl = friction
	if velocity.x >= max_speed:
		if Input.is_action_pressed("ui_right"):
			current_accl = 0
		elif Input.is_action_pressed("ui_left"):
			#current_accl = -brake
			is_stop = true
			direction = -1
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_right"):
			current_accl = sprint_accl
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_left"):
			current_accl = -sprint_brake
		else:
			current_accl = -friction
	if velocity.x <= -max_speed:
		if Input.is_action_pressed("ui_right"):
			#current_accl = brake
			is_stop = true
			direction = 1
		elif Input.is_action_pressed("ui_left"):
			current_accl = 0
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_right"):
			current_accl = sprint_brake
		elif Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_left"):
			current_accl = -sprint_accl
		else:
			current_accl = friction

	if is_stop:
		velocity.x = direction * accl * delta
	else:
		velocity.x += current_accl * delta
	
	var gravity = 0
	if velocity.y <= 0:
		gravity = jump_gravity
	else:
		gravity = fall_gravity
		
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		
	if Input.is_action_just_released("ui_up") and not is_on_floor() and velocity.y < 0:
		velocity.y *= jump_slowdown
	
	move_and_slide()
