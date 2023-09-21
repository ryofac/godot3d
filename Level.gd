extends Spatial

onready var playerScene = preload("res://Player.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var levelGrid = []
var width = 30
var height = 30
var inputCooldown = 0
var mapGrid: Array = []

const FLOOR = 0
const WALL = 1
const NORTH = 1
const WEST = 2
const EAST = 4
const SOUTH = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	initializeGrid()
#	print(mapGrid)
	
	for i in range(width):
		for j in range(height):
			# Piso:
			levelGrid.append(Vector3(i, 0, j))
			
			# Paredes das bordas
			if i == 0 or i == width - 1 or j == 0 or j == height - 1:
				levelGrid.append(Vector3(i, 1, j))
				
	# Definir posição do Controlador
	var _cx = width / 2
	var _cy = height / 2
	var _cdir = randi() % 4
	var _steps = 320
	
	var _direction_change_odds = 2
	for _n in range(_steps):
		mapGrid[_cx][_cy] = FLOOR
		
		var _str = "A posição é " + str(_cx) + " e " + str(_cy)
		print(_str)
		
		# Randomizar a direção
		if randi() % _direction_change_odds == 0:
			_cdir = randi() % 4
		
		var _ang = deg2rad(_cdir * 90)
		var _xDir = cos(_ang)
		var _yDir = sin(_ang)
		_cx += _xDir
		_cy += _yDir
		
		# Garantir que não vai sair da grid
		var _b = 2
		if _cx < _b or _cx >= width - 4:
			_cx += -_xDir * 2
		if _cy < _b or _cy >= height - 4:
			_cy += -_yDir * 2;
		
	# Remover paredes isoladas:
	for n in range(2):
		for x in range(1, width-1):
			for y in range(1, height-1):
				if (mapGrid[x][y] != FLOOR):
					var _northTile = int(mapGrid[x][y-1] == WALL)
					var _westTile = int(mapGrid[x-1][y-1] == WALL)
					var _eastTile = int(mapGrid[x+1][y-1] == WALL)
					var _southTile = int(mapGrid[x][y+1] == WALL)
					
					var _tileIndex = NORTH*_northTile + WEST*_westTile + EAST*_eastTile + SOUTH*_southTile + 1;
					if _tileIndex == 1:
						mapGrid[x][y] = FLOOR
					
					if n == 0:
						if _tileIndex == 2 or _tileIndex == 3 or _tileIndex == 5 or _tileIndex == 7 or _tileIndex == 10:
							mapGrid[x][y] = FLOOR


func initializeGrid():
	mapGrid.resize(width)
	for x in range(width):
		mapGrid[x] = []
		for y in range(height):
			mapGrid[x].append(WALL)


func spawnPlayer():
	var _pl = playerScene.instance()
	_pl.translation = $Walls.map_to_world(width/2, 10, height/2)
	add_child(_pl)


func setWallsCells():
	for x in range(width):
		for y in range(height):
			var _cell = mapGrid[x][y]
			if _cell == WALL:
				$Walls.set_cell_item(x, 1, y, 5)
				$Walls.set_cell_item(x, 2, y, 5)
				if x < 4 or x > width - 4 or y < 4 or y > height - 4:
					$Walls.set_cell_item(x, 3, y, 5)
				if randi() % 10 == 0:
					if $Walls.get_cell_item(x, 3, y) == -1:
						$Walls.set_cell_item(x, 3, y, 10)

		
	for cell in levelGrid:
		$Walls.set_cell_item(cell.x, cell.y, cell.z, 5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	inputCooldown = move_toward(inputCooldown, 0, 1)
	
	if Input.is_key_pressed(KEY_1) and inputCooldown <= 0:
		get_tree().reload_current_scene()
	
	if Input.is_key_pressed(KEY_0) and inputCooldown <= 0:
		inputCooldown = 30
		setWallsCells()
		spawnPlayer()
		$CameraPivot/Camera.current = true
		
	manageCamera()
	

func manageCamera():
	var _camHeight = 16;
	var player = get_node_or_null("Player")
	if player != null:
		$CameraPivot.set_translation($Walls.map_to_world(width/2, _camHeight, height))
		$CameraPivot.look_at(player.translation, Vector3.UP)
