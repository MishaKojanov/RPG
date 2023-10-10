extends Area2D

var rng = RandomNumberGenerator.new()


var player_in_range = false
var opened = false
var loot_amount = 3
var hearts_released = false

var scene = preload("res://scenes/heart.tscn")
var heart = scene.instantiate()
var hearts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("closed")
	$hint.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("open") && player_in_range && !opened:
		$AnimatedSprite2D.play("open")
		$hint.hide()
		opened = true



func _on_body_entered(body):
	if body.is_in_group("player") && !opened:
		$hint.show()
		player_in_range = true


func _on_body_exited(body):
	if body.is_in_group("player") && !opened:
		$hint.hide()
		player_in_range = false
