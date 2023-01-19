extends Node

export(PackedScene) var mob_scene
var score
#var timesOfSize = 0 #QW - 
var scaleIndex = 0.8 #QW - how much the player will be small each time
var minVelocity = 150.0 #QW - use for random velocity
var maxVelocity = 250.0 #QW - use for random velocity

func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	minVelocity = 150.0 #QW - reset the velocity
	maxVelocity = 250.0 #QW - reset the velocity
	$MobTimer.wait_time = 0.5 #QW - reset the Mob refresh time
	$Player.scale = Vector2(1,1) #QW - reset the player scale
	$Player.resetSpeed() #QW - reset the player speed
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$Player.restLive()#QW - reset the lives
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	$HUD.resetSize()#QW - reset the lives bar
	


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()
	var randomS = mob._setSize()#set the enemy differen size
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(minVelocity, maxVelocity), 0.0) #QW - change the random range by var
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_ScoreTimer_timeout():
	$MobTimer.wait_time -= 0.01 #QW - the enemy refresh will be quicker during time
	score += 1
	$HUD.update_score(score)
	if score%10==0: #QW - Player's scale will change each 10 second
		$Player.scale *= scaleIndex#QW 
	if score%5==0: #QW - enemy's speed and player's speed will increase each 5 second
		minVelocity += 50#QW 
		maxVelocity += 100#QW 
		$Player.addSpeed()#QW 


func _on_StartTimer_timeout(): 
	$MobTimer.start()
	$ScoreTimer.start()

func _on_Player_losingLive():#QW - when each time player lose live, play the music and change the lives bar size
	$loselive.play() #QW 
	$HUD.changeSize($Player.lives)#QW 
