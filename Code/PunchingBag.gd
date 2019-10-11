extends KinematicBody2D

# Declare member variables here. Examples:
#gravity
var grav = 600
# how fast badboy is moving
var vel = Vector2()
# whether badboy is facing right or not
export (bool) var rightFacing = true
# a negative or positive value based on badboy's facing (-1 for left, 1 for right)
var facingValue = 1
# if badboy is hurt and cannot act
var hurt

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	#Animations
	if !hurt:
		$AnimatedSprite.play("Hurt")
		yield(get_node("AnimatedSprite"), "animation_finished")
		hurt = false
	else:
		$AnimatedSprite.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# add gravity
	vel.y += grav * delta
	
	vel = move_and_slide(vel, Vector2(0, -1))