extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$player.position = $startingPos.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$camera.position = $player.position
	if $player.dead:
		$player.position = $startingPos.position
		$player.spawn()
	
