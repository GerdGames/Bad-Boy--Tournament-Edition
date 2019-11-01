extends Area2D

# Declare member variables here. Examples:
# The player it comes from
var player = 1
# how much damage it does
var dmg = 0
# how much hit stun it does
var htStn = 0
# how much block stun it does
var blkStn = 0
# positon
var pos = Vector2(0,0)
# size
var size = Vector2(0,0)
# how long the hitbox lasts
var lifetime = 1
# how old the hitbox is
var age = 0

var playerOwned;

# Called when the node enters the scene tree for the first time.
func _ready():
	age = 0
	position = pos
	$CollisionShape2D.get_shape().set_extents(size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if hitbox has reached its maximum lifetime
	if age >= lifetime:
		get_parent().remove_child(self)
	else:
		#increment age
		age += delta
		
func _initParent():
	connect("body_entered", self, "handle_area")
	
func handle_area(body):
	print("Handle Area");
	if (body != playerOwned):
		print(body);
		if(body.has_method("_take_hit")):
			body._take_hit(dmg, htStn, blkStn);
		print(playerOwned);
	return;

# Initialize variables
func initialize(p, d, h, b, ps, s, l, po):
	player = p
	dmg = d
	htStn = h
	blkStn = b
	pos = ps
	size = s
	lifetime = l
	playerOwned = po;
	_initParent();