extends Area2D

var player_in_range = false
var player_follow = false
var player = null
var speed = 16
var heal_amount = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_follow:
		position += (player.position - position)/speed


func hideHeart():
	position = Vector2(-1000,-1000)
	hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_follow = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player =  null
		player_follow = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		position = Vector2(-1000,-1000)
		hide()
		if body.health < body.max_health:
			body.health += heal_amount
