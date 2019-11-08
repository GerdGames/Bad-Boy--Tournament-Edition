extends KinematicBody2D

# member variables
# walking Speed
var groundSpeed = 75
# Jumping velocity
var jumpVel = -250
#gravity
var grav = 600
#health
var health = 100
var maxHealth = 100
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
func _hit() :
	pass
	
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
		if dir.x != 0:
			vel.x = groundSpeed * dir.x * facingValue
		else:
			if vel.x >= 10:
				vel.x = vel.x * 0.2
			else:
				vel.x = 0
	# if crouched or busy zero out ground velocity
	else:
		if vel.x >= 10:
			vel.x = vel.x * 0.2
		else:
			vel.x = 0
	# Play appropriate animation
	# if not busy or hurt
	if !busy:
		# if not busy, check to switch sides
		#if grounded
		if !airborne:
			#check facing
			if rightFacing:
				$AnimatedSprite.set_flip_h(false)
				$AnimatedSprite.offset.x = 10
				facingValue = 1
			else:
				$AnimatedSprite.set_flip_h(true)
				$AnimatedSprite.offset.x = -10
				facingValue = -1
			# if standing
			if !crouched:
				$CollisionShape2D.scale = Vector2(1, 1)
				$CollisionShape2D.position.y = 7
				# Light
				if Input.is_action_just_pressed(light):
					if $AnimatedSprite.get_animation() != "Light Punch":
						$AnimatedSprite.play("Light Punch")
						busy = true
						print("punch start")
						yield(get_node("AnimatedSprite"), "frame_changed")
						if $AnimatedSprite.get_frame() == 1:
							var lphb = hitBox.instance()
							lphb.initialize(player, 10, 1, 1, 300, Vector2(17 * facingValue, 3), Vector2(8 * facingValue, 4), .2, self)
							add_child(lphb)
						print("waiting for punch to end")
						yield(get_node("AnimatedSprite"), "animation_finished")
						busy = false
						print("punch end")
				# Heavy
				elif Input.is_action_just_pressed(heavy):
					if $AnimatedSprite.get_animation() != "Medium Punch":
						$AnimatedSprite.play("Medium Punch")
						busy = true
						yield(get_node("AnimatedSprite"), "animation_finished")
						busy = false
				# Jumping
				elif dir.y > 0:
					$AnimatedSprite.play("Jump Squat")
					busy = true
					yield(get_node("AnimatedSprite"), "animation_finished")
					busy = false
					# add jump impulse
					vel.x = groundSpeed * dir.x * facingValue
					vel.y = jumpVel
					#set airborne
					airborne = true
					
				# if crouching
				elif dir.y < 0:
					$AnimatedSprite.play("Crouching")
					busy = true
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
					busy = false
					$AnimatedSprite.play("Idle")
			# if crouching
			else:
				$CollisionShape2D.scale = Vector2(1.1, .7)
				$CollisionShape2D.position.y = 11
				# Light
				if Input.is_action_just_pressed(light):
					if $AnimatedSprite.get_animation() != "Crouch Kick":
						$AnimatedSprite.play("Crouch Kick")
						busy = true
						yield(get_node("AnimatedSprite"), "animation_finished")
						busy = false
				# stay crouched
				elif dir.y < 0:
					$AnimatedSprite.play("Crouched")
				else:
					$AnimatedSprite.play("Rising")
					busy = true
					yield(get_node("AnimatedSprite"), "animation_finished")
					crouched = false
					busy = false
		else:
			# Light
			if Input.is_action_just_pressed(light):
				$AnimatedSprite.play("Air Kick")
				busy = true
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
func _take_hit(damage, hitStun, blockStun, knockBack):
	#get_parent()._player_hit(player, damage);
	health -= damage;
	vel.x += knockBack * facingValue * -1
	# animation
	busy = true
	$AnimatedSprite.play("Hurt")
	yield(get_node("AnimatedSprite"), "animation_finished")
	busy = false
	# TODO: do something with hitstun and blockstun
	#print("taking hit, ouch");