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
var airborne = true
# whether badboy is facing right or not
var rightFacing = true
# how fast badboy is moving
var vel = Vector2()
# load in the hitbox object
var hitBox = preload("res://Code/Hitbox.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
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
		# if not busy, check to switch sides
		#if grounded
		if !airborne:
			# if standing
			if !crouched:
				# Light
				if Input.is_action_just_pressed("Light"):
					busy = true
					$AnimatedSprite.play("Light Punch")
					yield(get_node("AnimatedSprite"), "frame_changed")
					if $AnimatedSprite.get_frame() == 1:
						var lphb = hitBox.instance()
						lphb.initialize(1, 10, 1, 1, Vector2(7, 3), Vector2(8, 4), .3)
						add_child(lphb)
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
					busy = true
					$AnimatedSprite.play("Jump Squat")
					yield(get_node("AnimatedSprite"), "animation_finished")
					busy = false
					# add jump impulse
					vel.x = groundSpeed * dir.x
					vel.y = jumpVel
					#set airborne
					airborne = true
					
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
				# Light
				if Input.is_action_just_pressed("Light"):
					busy = true
					$AnimatedSprite.play("Crouch Kick")
					yield(get_node("AnimatedSprite"), "animation_finished")
					busy = false
				# stay crouched
				elif dir.y < 0:
					$AnimatedSprite.play("Crouched")
				else:
					busy = true
					$AnimatedSprite.play("Rising")
					yield(get_node("AnimatedSprite"), "animation_finished")
					crouched = false
					busy = false
		else:
			# Light
			if Input.is_action_just_pressed("Light"):
				busy = true
				$AnimatedSprite.play("Air Kick")
				yield(get_node("AnimatedSprite"), "animation_finished")
				busy = false
			#airborne
			else:
				$AnimatedSprite.play("Airborne")
func _physics_process(delta):
	# add gravity
	vel.y += grav * delta
	
	vel = move_and_slide(vel, Vector2(0, -1))
	#check if landing
	if airborne && is_on_floor():
		airborne = false
		busy = true
		$AnimatedSprite.play("Landing")
		yield(get_node("AnimatedSprite"), "animation_finished")
		busy = false
