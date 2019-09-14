extends Area2D

# Declare member variables here. Examples:
var groundSpeed = 300
#whether badboy can make other actions
var busy = false
#whether badboy is crouched or standing
var crouched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 400
	position.y = 500

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
	# Move appropriately
	# stop if not crouched
	if !crouched && !busy:
		position.x += groundSpeed * dir.x * delta
	
	# Play appropriate animation
	# if not busy
	if !busy:
		# if standing
		if !crouched:
			#light punch
			if Input.is_action_just_pressed("Light"):
				busy = true
				$AnimatedSprite.play("Light Punch")
				yield(get_node("AnimatedSprite"), "animation_finished")
				busy = false
			elif Input.is_action_just_pressed("Heavy"):
				busy = true
				$AnimatedSprite.play("Medium Punch")
				yield(get_node("AnimatedSprite"), "animation_finished")
				busy = false
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
		else:
			if dir.y < 0:
				$AnimatedSprite.play("Crouched")
			else:
				busy = true
				$AnimatedSprite.play("Rising")
				yield(get_node("AnimatedSprite"), "animation_finished")
				crouched = false
				busy = false