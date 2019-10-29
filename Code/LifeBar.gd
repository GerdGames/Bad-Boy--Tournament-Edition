extends Control

# Declare member variables here. Examples:
export (int) var player

var curHealth = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	if player == 2:
		#modify health bar border
		$HealthBarBorder.set_flip_h(true)
		#modify portrait
		$HealthBarBorder/Portrait.set_flip_h(true)
		$HealthBarBorder/Portrait.position.x = 45
		#modify health bar
		$HealthBarBorder/ProgressBar.set_rotation(0)
		$HealthBarBorder/ProgressBar.rect_position = Vector2(-53, -7)
	# get character from match and set portrait

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#update health bar
	$HealthBarBorder/ProgressBar.value = curHealth