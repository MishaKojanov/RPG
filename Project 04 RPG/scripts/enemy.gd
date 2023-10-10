extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null 
var player_inattack_zone = false
var player_attack_cooldown = true
var knockback = true
var damage = 20
var player_damage = 0

var health = 100
var max_health = 100
var health_width

func _ready():
	health_width = $health_bar.size.x

func _physics_process(delta):
	$health_bar.size.x = health_width * health/max_health
	deal_with_damage()
	if health > 0:
		if player_chase:
			if knockback:
				position += (player.position - position)/speed
			else:
				position -= 0.15*(player.position - position)
				$knockback.start()
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
		

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(body):
	player =  null
	player_chase = false


func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("player"):
		player_inattack_zone = true
		player_damage = body.damage


func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		player_inattack_zone = false
		
func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true and player_attack_cooldown == true:
		health -= player_damage
		print("Slime health: " + str(health))
		modulate = Color(1,0,0)
		$attack_cooldown.start()
		$hit.start()
		player_attack_cooldown = false
		knockback = false
		if health <= 0: 
			print("defeat")
			$AnimatedSprite2D.play("defeat")
			$health_bar.size.x = 0
			$health_outline.size.x = 0


func _on_attack_cooldown_timeout():
	player_attack_cooldown = true


func _on_hit_timeout():
	modulate = Color(1,1,1)


func _on_knockback_timeout():
	knockback = true # Replace with function body.


func _on_animated_sprite_2d_animation_finished():
	if health <= 0:
		self.queue_free()
