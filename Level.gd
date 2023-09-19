extends Spatial

onready var playerScene = preload("res://Player.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levelGrid = []
var width = 12
var height = 12
var inputCooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(width):
		for j in range(height):
			levelGrid.append(Vector3(i, 0, j))
			if i == 0 or i == width - 1 or j == 0 or j == height - 1:
				levelGrid.append(Vector3(i, 1, j))


func spawnPlayer():
	var _pl = playerScene.instance()
	_pl.translation = $Walls.map_to_world(width/2, 10, height/2)
	add_child(_pl)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inputCooldown = move_toward(inputCooldown, 0, 1)
	if Input.is_key_pressed(KEY_0) and inputCooldown <= 0:
		inputCooldown = 30
#		var _empty = $Walls.get_used_cells()
#		print(_empty)
		for cell in levelGrid:
			$Walls.set_cell_item(cell.x, cell.y, cell.z, 5)
		$CameraPivot.set_translation($Walls.map_to_world(width/2, 10, 10))
		spawnPlayer()
		$CameraPivot/Camera.current = true
		
	var player = get_node("Player")
	if player != null:
		$CameraPivot.look_at(player.translation, Vector3.UP)
