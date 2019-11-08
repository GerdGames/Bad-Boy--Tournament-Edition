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
# how far the player will get knocked back
var knockBack = 0
# positon
var pos = Vector2(0,0)
# size
var size = Vector2(0,0)
# how long the hitbox lasts
var lifetime = 1
# how old the hitbox is
var age = 0
# is attack overhead?
var overhead = false;
# is attack low?
var low = false;

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
	# print("Handle Area");
	if (body != playerOwned):
		# print(body);
		if(body.has_method("_take_hit")):
			body._take_hit(dmg, htStn, blkStn, knockBack, overhead, low);
		print(playerOwned);
	return;

# Initialize variables
func initialize(p, d, h, b, kb, ps, s, l, po, oh, lw):

	player = p
	dmg = d
	htStn = h
	blkStn = b
	knockBack = kb
	pos = ps
	size = s
	lifetime = l
	playerOwned = po;
	overhead = oh;
	low = lw;
	_initParent();