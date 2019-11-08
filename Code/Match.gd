extends Node2D

# Declare member variables here. Examples:
# starting time in match
#var timeStart
# time left in current round
#var timeLeft
# total rounds to win
#var roundsToWin
# player 1 rounds won
#var p1Rounds
# player 2 rounds won
#var p2Rounds
# player 1 scene
var p1Char = preload("res://Code/BadBoy.tscn")
# player 2 scene
var p2Char = preload("res://Code/BadBoy.tscn")
# player 1 palette
var p1Pal = 0
# player 2 palette
var p2Pal = 1
# player 1 health
var p1HP = 100
# player 2 health
var p2HP = 100
#player 1 object
var p1
#player 2 object
var p2 

#func _player_hit(player, dmg):
#	if (player != 1 && player != 2):
#		print("not a valid player");
#		return;
#	else:
#		print("player taking hit");
#		if (player == 1):
#			p1HP -= dmg;
#		else:
#			p2HP -= dmg;
#	return;

#resets the match after a win or after hitting the reset button in training mode
func reset():
	#health and position should be reset
	p1.position = Vector2(120, 140)
	p1.rightFacing = true
	p1.health = p1HP
	p2.position = Vector2(200, 140)
	p2.rightFacing = false
	p2.health = p2HP
	#rounds, characters, and palettes shouldn't
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize game variables 0 wins, 99 time, 100 health etc.
	# spawn characters
	# spawn player 1
	p1 = p1Char.instance()
	p1.player = 1;
	p1.position = Vector2(120, 140)
	p1.palette = p1Pal
	p1.rightFacing = true
	p1.health = p1HP
	add_child(p1)
	#set up player 1 healthbar
	$HUD/LifeBarP1.curHealth = p1.health
	# spawn player 2
	p2 = p2Char.instance()
	p2.player = 2;
	p2.position = Vector2(200, 140)
	p2.palette = p2Pal
	p2.rightFacing = false
	p2.health = p2HP
	add_child(p2)
	#set up player 2 healthbar
	$HUD/LifeBarP2.curHealth = p2.health
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#decrement timer
		#if timer 0 player with more health wins
			#if players have equal health tie and no one wins
	#update health bars
	#player 1 health bar
	$HUD/LifeBarP1.curHealth = p1.health
	#player 2 health bar
	$HUD/LifeBarP2.curHealth = p2.health
	#check if either player has 0 health
	if (p1.health <= 0) or (p2.health <= 0):
		# if both players have 0 health tie and no one wins
		if (p1.health <= 0) and (p2.health <= 0):
			#no rounds awarded
			#tie game message
			var tMSG = Label.instance()
			#wait
			#reset
			reset()
		# otherwise if p2 has 0 health p1 wins and vice versa
		elif (p1.health <= 0):
			#round awarded to player 2
			#check if player 2 has won enough rounds to win the match 
			#player 2 wins message
			#wait
			#reset
			reset()
		elif (p2.health <= 0):
			#round awarded to player 1
			#check if player 1 has won enough rounds to win the match 
				#if so 
			#player 1 wins message
#			var p1MSG = Label.new()
#			p1MSG.set_text('Player 1 wins!')
#			p1MSG.show_on_top = true
#			add_child(p1MSG)
#			#wait
#			yield(get_tree().create_timer(1.0), "timeout")
#			get_parent().remove_child(p1MSG)
			#reset
			reset()
	#check facing if p1 is left of p2 set p1 to face right and p2 to face left
	if p1.position.x < p2.position.x + 10:
		p1.rightFacing = true
		p2.rightFacing = false
	elif p1.position.x > p2.position.x - 10:
		p1.rightFacing = false
		p2.rightFacing = true
	
	#check for reset button
	if Input.is_action_just_pressed('reset'):
		reset()
#	pass
