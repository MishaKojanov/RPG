extends Node2D

var rng = RandomNumberGenerator.new()

var scene = preload("res://scenes/heart.tscn")
var heart = scene.instantiate()
var hearts = []


var scene2 = preload("res://scenes/chest.tscn")
var chest = scene2.instantiate()
var chests = []
var number_of_chests = 10

var scene3 = preload("res://scenes/enemy.tscn")
var enemy = scene3.instantiate()
var enemies = []
var number_of_enemies = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$player.position = $startingPos.position
	
	#spawn chests
	for i in range(number_of_chests):
		var x = rng.randi_range(0, 50)
		var y = rng.randi_range(0, 30)
		chest = scene2.instantiate()
		chest.position = Vector2(x*16, y*16)
		chests.append(chest)
		add_child(chest)
		
	#spawn enemies
	for i in range(number_of_enemies):
		var x = rng.randi_range(0, 50)
		var y = rng.randi_range(0, 30)
		enemy = scene3.instantiate()
		enemy.position = Vector2(x*16, y*16)
		enemies.append(enemy)
		add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$camera.position = $player.position
	if $player.dead:
		$player.position = $startingPos.position
		$player.spawn()
	
	for Chest in chests:
		if Chest.opened:
			chests.erase(Chest)
			Chest.hearts_released = true
			for i in range(Chest.loot_amount):
				heart = scene.instantiate()
				var x = Chest.position.x + rng.randi_range(-16, 16)
				var y = Chest.position.y + rng.randi_range(-16, 16)
				heart.position = Vector2(x,y)
				hearts.append(heart)
				add_child(heart)
	
