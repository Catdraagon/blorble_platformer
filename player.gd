extends CharacterBody2D

var fall_gravity = 3000
var jump_gravity = 500
var jump_force = -700
var jump_slowdown = 0.5

var accl = 8000
var sprint_accl = 10000
var friction = 4000
var max_speed = 600
var sprint_max_speed = 1500
var brake = 70000
var sprint_brake = 10000

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

	velocity.x += current_accl * delta

	if Input.is_action_pressed("ui_shift"):
		velocity.x = clamp(velocity.x, -sprint_max_speed, sprint_max_speed)
	else:
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
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
