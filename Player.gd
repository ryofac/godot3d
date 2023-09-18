extends KinematicBody
export var speed : float = 5.5;
export var jump_impulse: float = 20.0;
export var gravity: float = 30.0;


var velocity: Vector3 = Vector3.ZERO;
var direction: Vector3 = Vector3.ZERO;



func _ready() -> void:
	pass

func _physics_process(delta) -> void:
	var direction = get_direction()
	var cam = get_parent().get_node("CameraPivot")


	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_impulse
	
	
	# MAnage SpringArm
	var springarm = get_node("SpringArm");
#	springarm.translation = translation - Vector3.BACK * 5
#	springarm.translation.y = 4

	# Manage Sprites
	if !is_on_floor():
		# ṔPulando
		$"Pivot/character-human/AnimationPlayer".play("jump")
	else:
		if velocity != Vector3.ZERO:
			$"Pivot/character-human/AnimationPlayer".play("sprint")
		else:
			$"Pivot/character-human/AnimationPlayer".play("idle")
		
		
	if direction != Vector3.ZERO:
		$Pivot.look_at(translation - get_direction(), Vector3.UP)
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP) 
	
	
	

	

func get_direction() -> Vector3:
	direction.x = Input.get_axis("move_left", "move_right");
	direction.z = Input.get_axis("move_forward", "move_back");
	return direction.normalized() if direction != Vector3.ZERO else Vector3.ZERO;
	
