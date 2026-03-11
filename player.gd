extends CharacterBody2D

var accl = 8000
var sprint_accl = 40000
var fall_gravity = 3000
var jump_gravity = 500
var jump_force = -700
var jump_slowdown = 0.5
var friction = 4000
var max_speed = 400
var max_sprint_speed = 1000

func _physics_process(delta):
	var current_accl = accl
	var current_max_speed = max_speed
	if Input.is_action_pressed("ui_shift"):
		current_accl = sprint_accl
		current_max_speed = max_sprint_speed
		# TODO make braking more smooth
	if abs(velocity.x) != max_sprint_speed or not Input.is_action_pressed("ui_shift") or not (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) or Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
		if velocity.x > 0:
			velocity.x -= friction * delta
		elif velocity.x < 0:
			velocity.x += friction * delta
	if not abs(velocity.x) >= max_speed and Input.is_action_pressed("ui_right"):
		velocity.x += current_accl * delta
	if not abs(velocity.x) >= max_speed and Input.is_action_pressed("ui_left"):
		velocity.x -= current_accl * delta
	if velocity.x > current_max_speed:
		velocity.x = current_max_speed
	elif velocity.x < -current_max_speed:
		velocity.x = -current_max_speed
	
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
