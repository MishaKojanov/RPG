extends CharacterBody2D


#Player's speed
const speed = 100
#Players current direction
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	

func _physics_process(delta):
	player_movement(delta)

#Move and animate player based based on input	
func player_movement(delta):
	#Grid based player movement logic
	if Input.is_action_pressed("move_right"):
		current_dir = "right"
		play_animation(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("move_left"):
		current_dir = "left"
		play_animation(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("move_up"):
		current_dir = "up"
		play_animation(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("move_down"):
		current_dir = "down"
		play_animation(1)
		velocity.x = 0
		velocity.y = speed
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()
	
func play_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D
	
	if dir == "right" || dir == "left":
		if dir == "right":
			animation.flip_h = false
		else:
			animation.flip_h = true
		if movement  == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	else:
		if movement  == 1:
			animation.play(str(dir)+"_walk")
		elif movement == 0:
			animation.play(str(dir)+"_idle")
