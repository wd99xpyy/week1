extends Area2D

signal hit
signal losingLive

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var lives = 3 #QW - player lives
var attavkable = true #QW - is player can be attack
var loseLiveCD = 2 #QW - the cd of losing live

var tailAttackable = preload("res://art/tailAttact.png") #QW - import tail's image when it is attackable
var tailNotAttackable = preload("res://art/tailNotAttact.png") #QW - import tail's image when it is not attackable

func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func addSpeed(): #QW - add player's speed
	speed += 50#QW

func resetSpeed():#QW - reset player's speed
	speed = 400#QW

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func loseLive():#QW - lose live
	lives -= 1#QW 

func getLive():#QW - get live - not used
	lives += 1#QW 

func restLive():#QW - reset live
	lives = 3#QW 

func setAttackable():#QW - change player to attackable
	attavkable = true#QW 
	$Trail.set_texture(tailAttackable)#QW - change the tail texture
	
func setUnAttackable():#QW - change the player not attackable
	attavkable = false#QW 
	$Trail.set_texture(tailNotAttackable)#QW - change the tail texture

func _on_Player_body_entered(_body):
	if(attavkable):#QW - check is player attackable
		if(lives<=0):#QW go death
			hide() # Player disappears after being hit.
			emit_signal("hit")
			# Must be deferred as we can't change physics properties on a physics callback.
			$CollisionShape2D.set_deferred("disabled", true)
		else:#QW lose live
			loseLive()#QW 
			emit_signal("losingLive")#QW - give signal to the main sence that player lose lives
			setUnAttackable()#QW - go to the cd of lose live
			$CDTimer.start()#QW - cd timer begin
			#print(lives)
			#print(attavkable)
			
		
func _on_CDTimer_timeout():#QW - record the cd time
	#print(loseLiveCD)
	if(!attavkable):#QW check attackable
		loseLiveCD -= 1 #QW - decrease cd
		if(loseLiveCD==0): #QW - when cd end
			setAttackable() #QW 
			loseLiveCD = 2 #QW reset cd
			$CDTimer.stop()#QW 
			
		
		

