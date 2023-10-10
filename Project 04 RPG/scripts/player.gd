extends CharacterBody2D


#Player's speed
var speed = 100
var og_speed = speed

#Players current direction
var current_dir = "none"

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var enemy_damage = 0
var player_alive = true
var attacking = false
var damage = 20
var dead = false

var health = 100
var max_health = 100
var stamina = 100
var max_stamina = 100
var recovering_stamina = false
var health_width
var stamina_width

func _ready():
	health_width = $health_bar.size.x
	stamina_width = $stamina_bar.size.x
	spawn()
	
func spawn():
	$AnimatedSprite2D.play("down_idle")
	health = max_health
	stamina = max_stamina
	$health_bar.size.x = health_width
	$stamina_bar.size.x = stamina_width
	$health_outline.size.x = health_width + 2
	$stamina_outline.size.x = stamina_width + 2
	dead = false

func _physics_process(delta):
	if health <= 0:
		enemy_inattack_range = false
		$AnimatedSprite2D.play("defeat")
		$health_bar.size.x = 0
		$stamina_bar.size.x = 0
		$health_outline.size.x = 0
		$stamina_outline.size.x = 0
	else:
		player_movement(delta)
		enemy_attack()
		attack()
		$health_bar.size.x = health_width * health/max_health
		$stamina_bar.size.x = stamina_width * stamina/max_stamina
	

#Move and animate player based based on input	
func player_movement(delta):
	#sprinting
	if recovering_stamina && stamina < 100:
		stamina += 0.5
	if Input.is_action_pressed("sprint") && stamina > 0:
		speed = og_speed*1.25
		stamina -= 0.5
		recovering_stamina = false
	else:
		if speed > og_speed:
			print("strat")
			$StaminaDelay.start()
		speed = og_speed/1.25
	
	if Input.is_action_pressed("move_right") && !attacking:
		current_dir = "right"
		play_animation(1)
		if Input.is_action_pressed("move_up"):
			velocity.y = -speed*speed/sqrt(2*pow(speed,2))
			velocity.x = speed*speed/sqrt(2*pow(speed,2))
		elif Input.is_action_pressed("move_down"):
			velocity.y = speed*speed/sqrt(2*pow(speed,2))
			velocity.x = speed*speed/sqrt(2*pow(speed,2))
		else:
			velocity.x = speed
			velocity.y = 0
	elif Input.is_action_pressed("move_left") && !attacking:
		current_dir = "left"
		play_animation(1)
		if Input.is_action_pressed("move_up"):
			velocity.y = -speed*speed/sqrt(2*pow(speed,2))
			velocity.x = -speed*speed/sqrt(2*pow(speed,2))
		elif Input.is_action_pressed("move_down"):
			velocity.y = speed*speed/sqrt(2*pow(speed,2))
			velocity.x = -speed*speed/sqrt(2*pow(speed,2))
		else:
			velocity.x = -speed
			velocity.y = 0
	elif Input.is_action_pressed("move_up") && !attacking:
		current_dir = "up"
		play_animation(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("move_down") && !attacking:
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
	if attacking == true:
		pass
	elif dir == "right" || dir == "left":
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


func _on_player_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_inattack_range = true
		enemy_damage = body.damage


func _on_player_hitbox_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health -= enemy_damage
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("player health: " + str(health))

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attacking = false
	

func attack():
	var dir = current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attacking = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			print("right atatck")
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
		if dir == "down":
			$AnimatedSprite2D.play("down_attack")
		if dir == "up":
			$AnimatedSprite2D.play("up_attack")
		$deal_attack_timer.start()


func _on_animated_sprite_2d_animation_finished():
	dead = true


func _on_stamina_delay_timeout():
	recovering_stamina = true
