extends CharacterBody2D

var accl = 8000
var sprint_accl = 10000
var friction = 4000
var max_speed = 600
var sprint_max_speed = 1300
var brake = 70000
var sprint_brake = 10000
var jump_height = 400
var jump_time = 0.65
var fall_time = 0.55
var jump_stop_multiplier = 0.5

var jump_velocity = 2 * jump_height / jump_time
var jump_accl = 2 * jump_height / (jump_time ** 2)
var fall_accl = 2 * jump_height / (fall_time ** 2)

func get_jump_accl() -> float:
	if velocity.y < 0:
		return jump_accl
	return fall_accl

func get_acceleration(none, right, left, shift_right, shift_left) -> float:
	if Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_right"):
		return shift_right
	if Input.is_action_pressed("ui_shift") and Input.is_action_pressed("ui_left"):
		return shift_left
	if Input.is_action_pressed("ui_right"):
		return right
	if Input.is_action_pressed("ui_left"):
		return left
	return none

func _physics_process(delta):
	var old_v_x = velocity.x
	var current_accl = 0
	if velocity.x == 0:
		current_accl = get_acceleration(0, accl, -brake, sprint_accl, -sprint_brake)
	if velocity.x > 0:
		current_accl = get_acceleration(-friction, accl, -brake, sprint_accl, -sprint_brake)
	if velocity.x < 0:
		current_accl = get_acceleration(friction, brake, -accl, sprint_brake, -sprint_accl)
	if velocity.x >= max_speed:
		current_accl = get_acceleration(-friction, 0, -brake, sprint_accl, -sprint_brake)
	if velocity.x <= -max_speed:
		current_accl = get_acceleration(friction, brake, 0, sprint_brake, -sprint_accl)
	if velocity.x >= sprint_max_speed:
		current_accl = get_acceleration(-friction, -friction, -brake, 0, -sprint_brake)
	if velocity.x <= -sprint_max_speed:
		current_accl = get_acceleration(friction, brake, friction, sprint_brake, 0)

	#print(current_accl)
	velocity.x += current_accl * delta

	if Input.is_action_pressed("ui_shift"):
		velocity.x = clamp(velocity.x, -sprint_max_speed, sprint_max_speed)
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	else:
		if old_v_x > 0:
			velocity.x = max(velocity.x, 0)
		elif old_v_x < 0:
			velocity.x = min(0, velocity.x)

	velocity.y += get_jump_accl() * delta
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		print(jump_velocity)
		velocity.y = -jump_velocity

	if Input.is_action_just_released("ui_up") and velocity.y < 0:
		velocity.y *= jump_stop_multiplier
		
	move_and_slide()
