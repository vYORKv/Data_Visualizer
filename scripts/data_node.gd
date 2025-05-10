extends CharacterBody2D

@onready var Circle: ColorRect = $ColorRect

const ACCELERATION: int = 200
var speed: int = 300 

var color_value: Color
var target: Object
var travel_permitted: bool = false

func SetColor(color: Color) -> void:
	Circle.set_color(color)
	color_value = Circle.get_color()

func BlendColor(color: Color) -> void:
	if color == Color(0,0,0,0):
		print("passed")
		pass
	else:
		print("Color: " +str(color))
		print("Color Value: " +str(color_value))
		var blended_color: Color = (color_value - color) + Color(0,0,0,1)
		print("Blended Color: " +str(blended_color))
		Circle.set_color(blended_color)
		color_value = Circle.get_color()

func _physics_process(delta: float) -> void:
	if travel_permitted:
		Travel(delta)

func Travel(delta: float) -> void:
	var target_pos: Vector2 = target.position
	var distance_to_target: float = self.global_position.distance_to(target_pos)
	if distance_to_target > 5:
		var direction: Vector2 = (target.global_position - self.global_position).normalized()
		velocity = velocity.move_toward(direction * speed, ACCELERATION * delta)
	elif distance_to_target < 5:
		travel_permitted = false
		velocity = Vector2.ZERO
	move_and_slide()

func NodeArrival(b_color: Color, new_t: Object) -> void:
	await get_tree().create_timer(.5).timeout
	target = new_t
	BlendColor(b_color)
	travel_permitted = true
