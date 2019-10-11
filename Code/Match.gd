extends Node2D

# Declare member variables here. Examples:
# starting time in match
var timeStart
# time left in current round
var timeLeft
# total rounds to win
var roundsToWin
# player 1 rounds won
var p1Rounds
# player 2 rounds won
var p2Rounds
# player 1 character
var p1Char = preload("res://Code/BadBoy.tscn")
# player 2 character
var p2Char = preload("res://Code/BadBoy.tscn")
# player 1 palette
var p1Pal = 0
# player 2 palette
var p2Pal = 1
# player 1 health
var p1HP
# player 2 health
var p2HP


# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize game variables 0 wins, 99 time, 100 health etc.
	# spawn characters
	# spawn player 1
	var p1 = p1Char.instance()
	p1.player = 1;
	p1.position = Vector2(120, 140)
	p1.palette = p1Pal
	p1.rightFacing = true
	add_child(p1)
	# spawn player 2
	var p2 = p2Char.instance()
	p2.player = 2;
	p2.position = Vector2(200, 140)
	p2.palette = p2Pal
	p2.rightFacing = false
	add_child(p2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#decrement timer
		#if timer 0 player with more health wins
			#if players have equal health tie and no one wins
	#check if either player has 0 health
		# if both players have 0 health tie and no one wins
		# otherwise if p2 has 0 health p1 wins and vice versa
	#check facing if p1 is left of p2 set p1 to face right and p2 to face left
#	pass
