extends RigidBody2D

func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

func _setSize(): #QW - random set the size of the mob/enemy?
	var randomSizeM =float( 2 + randi()%7) #QW - random a num from 2-9, change it to float
	randomSizeM = randomSizeM/10 #QW - Convert it to decimals
	# at here I just reset all element's scale in mob because it will be covert if I just change mob's
	$AnimatedSprite.scale = Vector2(randomSizeM,randomSizeM)#QW - set mob scale
	$CollisionShape2D.scale = Vector2(randomSizeM,randomSizeM)#QW - set mob scale
	$VisibilityNotifier2D.scale = Vector2(randomSizeM,randomSizeM)#QW - set mob scale
	$".".scale = Vector2(randomSizeM,randomSizeM)#QW - set mob scale
	return randomSizeM#QW - let main page know the size, just for check it work well

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
