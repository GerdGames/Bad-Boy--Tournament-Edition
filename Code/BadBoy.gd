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
export (bool) var rightFacing = true
# a negative or positive value based on badboy's facing (-1 for left, 1 for right)
var facingValue = 1
# how fast badboy is moving
var vel = Vector2()
# load in the hitbox object
var hitBox = preload("res://Code/Hitbox.tscn")
# index of the palette to use
export (int) var palette = 0
# Called when the node enters the scene tree for the first time.
export (int) var player = 0;
func _ready():
	# Set the palette
	# check if palette 1
	if palette == 1:
		var pal = load("res://Bad Boy Sprites/Rusty/BadBoyRustySprites.tres")
		$AnimatedSprite.set_sprite_frames(pal)
	# otherwise set to the default palette
	else:
		var pal = load("res://Bad Boy Sprites/Originals/BadBoyOriginalSprites.tres")
		$AnimatedSprite.set_sprite_frames(pal)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	var prefix = str("p" , (player) );
	var light = str(prefix , "_light");
	var heavy = str(prefix , "_heavy");
	var left = str(prefix , "_left");
	var right = str(prefix , "_right");
	var up = str(prefix , "_up");
	var down = str(prefix , "_down");
	
	#what direction the stick is in
	var dir = Vector2()
	# Get current stick direction
	if Input.is_action_pressed(right):
		dir.x += facingValue
	if Input.is_action_pressed(left):
		dir.x -= facingValue
	if Input.is_action_pressed(down):
		dir.y -= 1
	if Input.is_action_pressed(up):
		dir.y += 1
	
	# add horizontal movement
	# if airborne keep same horizontal velocity
	if airborne:
		vel.x = vel.x
	# if standing and not busy or airborne add ground velocity
	elif !crouched && !busy:
		vel.x = groundSpeed * dir.x * facingValue
	# if crouched or busy zero out ground velocity
	else:
		vel.x = 0
	
	# Play appropriate animation
	# if not busy
	if !busy:
		# if not busy, check to switch sides
		#if grounded
		if !airborne:
			#check facing
			if rightFacing:
				$AnimatedSprite.set_flip_h(false)
				facingValue = 1
				$CollisionShape2D.position = Vector2(-10, 7)
			else:
				$AnimatedSprite.set_flip_h(true)
				facingValue = -1
				$CollisionShape2D.position = Vector2(10, 7)
			# if standing
			if !crouched:
				# Light
				if Input.is_action_just_pressed(light):
					busy = true
					$AnimatedSprite.play("Light Punch")
					yield(get_node("AnimatedSprite"), "frame_changed")
					if $AnimatedSprite.get_frame() == 1:
						var lphb = hitBox.instance()
						lphb.initialize(1, 10, 1, 1, Vector2(7 * facingValue, 3), Vector2(8 * facingValue, 4), .2)
						add_child(lphb)
					yield(get_node("AnimatedSprite"), "animation_finished")
					busy = false
				# Heavy
				elif Input.is_action_just_pressed(heavy):
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
					vel.x = groundSpeed * dir.x * facingValue
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
				if Input.is_action_just_pressed(light):
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
			if Input.is_action_just_pressed(light):
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
