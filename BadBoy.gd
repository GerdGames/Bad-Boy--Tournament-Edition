extends KinematicBody2D

# member variables
# walking Speed
var groundSpeed = 75
# Jumping velocity
var jumpVel = -250
#gravity
var grav = 600
# whether badboy can make other actions
var busy = false
# whether badboy is crouched or standing
var crouched = false
# whether badboy is airborne or not
# warning-ignore:unused_class_variable
var airborne = true
# how fast badboy is moving
var vel = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
#	position.x = 400
#	position.y = 500
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	#what direction the stick is in
	var dir = Vector2()
	# Get current stick direction
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y -= 1
	if Input.is_action_pressed("ui_up"):
		dir.y += 1
	
	# add horizontal movement
	# if airborne keep same horizontal velocity
	if airborne:
		vel.x = vel.x
	# if standing and not busy or airborne add ground velocity
	elif !crouched && !busy:
		vel.x = groundSpeed * dir.x
	# if crouched or busy zero out ground velocity
	else:
		vel.x = 0
	
	# Play appropriate animation
	# if not busy
	if !busy:
		#if grounded
		if !airborne:
			# if standing
			if !crouched:
				# Light
				if Input.is_action_just_pressed("Light"):
					busy = true
					$AnimatedSprite.play("Light Punch")
					yield(get_node("AnimatedSprite"), "animation_finished")
					busy = false
				# Heavy
				elif Input.is_action_just_pressed("Heavy"):
					busy = true
					$AnimatedSprite.play("Medium Punch")
					yield(get_node("AnimatedSprite"), "animation_finished")
					busy = false
				# Jumping
				elif dir.y > 0:
#					busy = true
#					$AnimatedSprite.play("Jump Squat")
#					yield(get_node("AnimatedSprite"), "animation_finished")
#					busy = false
					#set airborne
					airborne = true
					# add jump impulse
					vel.y = jumpVel
				# if crouching
				elif dir.y < 0:
					busy = true
					$AnimatedSprite.play("Crouching")
					yield(get_node("AnimatedSprite"), "animation_finished")
					busy = false
					if dir.y < 0:
						crouched = true
					else:
						crouched = false
				# if moving forward
				elif dir.x > 0:
					$AnimatedSprite.play("Walk Forward")
				
				# if moving back
				elif dir.x < 0:
					$AnimatedSprite.play("Walk Forward", true)
				
				# if neither
				else:
					$AnimatedSprite.play("Idle")
			# if crouching
			else:
				if dir.y < 0:
					$AnimatedSprite.play("Crouched")
				else:
					busy = true
					$AnimatedSprite.play("Rising")
					yield(get_node("AnimatedSprite"), "animation_finished")
					crouched = false
					busy = false
		else:
			#airborne
			$AnimatedSprite.play("Airborne")
func _physics_process(delta):
	# add gravity
	vel.y += grav * delta
	#check if landing
	if airborne && is_on_floor():
		airborne = false
	move_and_slide(vel, Vector2(0, -1))