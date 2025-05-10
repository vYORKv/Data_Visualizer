extends Node2D

const DATA_NODE: Object = preload("res://scenes/data_node.tscn")

# Nodes
@onready var GreenNode: Marker2D = $GreenNode
@onready var RedNode: Marker2D = $RedNode
@onready var OrangeNode: Area2D = $OrangeNode
@onready var PurpleNode: Area2D = $PurpleNode
@onready var YellowNode: Area2D = $YellowNode
@onready var BlueNode: Area2D = $BlueNode
@onready var Result1: Area2D = $Result1
@onready var Result2: Area2D = $Result2
@onready var ResultFinal: Area2D = $ResultFinal

# Node Circles
@onready var GreenNodeCircle: ColorRect = $GreenNode/ColorRect
@onready var RedNodeCircle: ColorRect = $RedNode/ColorRect
@onready var OrangeNodeCircle: ColorRect = $OrangeNode/ColorRect
@onready var PurpleNodeCircle: ColorRect = $PurpleNode/ColorRect
@onready var YellowNodeCircle: ColorRect = $YellowNode/ColorRect
@onready var BlueNodeCircle: ColorRect = $BlueNode/ColorRect
@onready var Result1Circle: ColorRect = $Result1/ColorRect
@onready var Result2Circle: ColorRect = $Result2/ColorRect
@onready var ResultFinalCircle: ColorRect = $ResultFinal/ColorRect

# Node Labels
@onready var GreenNodeLabel: Label = $GreenNode/Label
@onready var RedNodeLabel: Label = $RedNode/Label
@onready var OrangeNodeLabel: Label = $OrangeNode/Label
@onready var PurpleNodeLabel: Label = $PurpleNode/Label
@onready var YellowNodeLabel: Label = $YellowNode/Label
@onready var BlueNodeLabel: Label = $BlueNode/Label
@onready var Result1Label: Label = $Result1/Label
@onready var Result2Label: Label = $Result2/Label
@onready var ResultFinalLabel: Label = $ResultFinal/Label

# Color Values for nodes within scene
var green: Color = Color(0.0627, 0.9137, 0.1216, 1.0)
var red: Color = Color(0.9059, 0.0431, 0.0549, 1.0)
var orange: Color #= Color(1.0, 0.6471, 0.0, 1.0)
var purple: Color #= Color(0.502, 0.0, 0.502, 1.0)
var yellow: Color #= Color(1.0, 1.0, 0.0, 1.0)
var blue: Color #= Color(0.0, 0.0, 1.0, 1.0)
var result_1_color: Color
var result_2_color: Color
var result_final_color: Color

# Count variables keeping track of variables reaching each node
var green_count: int = 0
var red_count: int = 0
var orange_count: int = 0
var purple_count: int = 0
var yellow_count: int = 0
var blue_count: int = 0
var result_1_count: int = 0
var result_2_count: int = 0
var result_final_count: int = 0

func _ready() -> void:
	### The original node names of "orange", "purple", "yellow", and "blue" are
	### still used though the colors do not match the names. This is due to color
	### blending not having desired effect with original color desicions. For this
	### reason, we define the color values of these nodes by drawing their colors
	### from each nodes color rectangle with the .get_color() function.
	orange = OrangeNodeCircle.get_color()
	purple = PurpleNodeCircle.get_color()
	yellow = YellowNodeCircle.get_color()
	blue = BlueNodeCircle.get_color()

func _process(_delta: float) -> void:
	### We use _process instead of _physics_process to update ui elements in 
	### all projects. _process gets processed every frame, but _physics_process
	### is called every physics frame (default is 60). We want ui to always 
	### update accurately with every frame, and _physics_process should only
	### be used for physics objects that need a consistent movement.
	### This means that the data in our labels is updating with the "count"
	### and "color" variables every new frame that is drawn while within the
	### _process function.
	GreenNodeLabel.text = "Count: " + str(green_count)
	RedNodeLabel.text = "Count: " + str(red_count)
	OrangeNodeLabel.text = "Count: " + str(orange_count)
	PurpleNodeLabel.text = "Count: " + str(purple_count)
	YellowNodeLabel.text = "Count: " + str(yellow_count)
	BlueNodeLabel.text = "Count: " + str(blue_count)
	Result1Label.text = "Count: " + str(result_1_count) + "\n" + "RGB: " + str(result_1_color)
	Result2Label.text = "Count: " + str(result_2_count) + "\n" + "RGB: " + str(result_2_color)
	ResultFinalLabel.text = "Count: " + str(result_final_count) + "\n" + "RGB: " + str(result_final_color)

func _on_button_pressed() -> void:
	var data: Object = DATA_NODE.instantiate()
	add_child(data)
	var spawn_i: int = randi_range(1,2) # Randomly assigning spawn
	var target_i: int = randi_range(1,2) # Randomly assigning first target
	if spawn_i == 1: # Spawns data point on green node and sets value to green
		data.position = GreenNode.global_position
		data.SetColor(green) 
		if target_i == 1: # Targets OrangeNode
			data.target = OrangeNode
		elif target_i == 2: # Targets PurpleNode
			data.target = PurpleNode
		green_count += 1
	elif spawn_i == 2: # Spawns data point on red node and sets value to red
		data.position = RedNode.global_position
		data.SetColor(red)
		if target_i == 1: # Targets YellowNode
			data.target = YellowNode
		elif target_i == 2: # Targets BlueNode
			data.target = BlueNode
		red_count += 1
	data.travel_permitted = true # Allows node to begin movement after all values set

### All functions below are body_entered signal functions that trigger once the data
### node has reached them. Each of these functions modify the value of the data
### node and points the data node to a new target by calling the NodeArrival
### function inside the data node's script (passing the new value and target as
### arguments). The way these values are calculated is abritary with no real 
### meaning aside from being visually pleasing in how they are represented.
### This is visual goal is responsible for why the node names in the scene tree
### do not match the actual colors represented in the program (aside from red
### and green).
func _on_orange_node_body_entered(body: Node2D) -> void:
	body.NodeArrival(orange, Result1)
	orange_count += 1

func _on_purple_node_body_entered(body: Node2D) -> void:
	var target_i: int = randi_range(1,2)
	if target_i == 1:
		body.NodeArrival(purple, Result1)
	elif target_i == 2:
		body.NodeArrival(purple, Result2)
	purple_count += 1

func _on_yellow_node_body_entered(body: Node2D) -> void:
	var target_i: int = randi_range(1,2)
	if target_i == 1:
		body.NodeArrival(yellow, Result1)
	elif target_i == 2:
		body.NodeArrival(yellow, Result2)
	yellow_count += 1

func _on_blue_node_body_entered(body: Node2D) -> void:
	body.NodeArrival(orange, Result2)
	blue_count += 1

func _on_result_1_body_entered(body: Node2D) -> void:
	if result_1_count == 0:
		body.NodeArrival(Color(0,0,0,0), ResultFinal)
		var d_color: Color = body.color_value
		Result1Circle.set_color(d_color)
		result_1_color = d_color
		result_1_count += 1
	else:
		var d_color: Color = body.color_value
		var blended_color: Color = (d_color - result_1_color) + Color(0,0,0,1)
		body.NodeArrival(result_1_color, ResultFinal)
		Result1Circle.set_color(blended_color)
		result_1_color = blended_color
		result_1_count += 1

func _on_result_2_body_entered(body: Node2D) -> void:
	if result_2_count == 0:
		body.NodeArrival(Color(0,0,0,0), ResultFinal)
		var d_color: Color = body.color_value
		Result2Circle.set_color(d_color)
		result_2_color = d_color
		result_2_count += 1
	else:
		var d_color: Color = body.color_value
		var blended_color: Color = (d_color - result_2_color) + Color(0,0,0,1)
		body.NodeArrival(result_2_color, ResultFinal)
		Result2Circle.set_color(blended_color)
		result_2_color = blended_color
		result_2_count += 1

func _on_result_final_body_entered(body: Node2D) -> void:
	if result_final_count == 0:
		var d_color: Color = body.color_value
		ResultFinalCircle.set_color(d_color)
		result_final_color = d_color
		result_final_count += 1
		body.queue_free() # Frees the data scene from parent scene and program memory
	else:
		var d_color: Color = body.color_value
		var blended_color: Color = (d_color - result_final_color) + Color(0,0,0,1)
		ResultFinalCircle.set_color(blended_color)
		result_final_color = blended_color
		result_final_count += 1
		body.queue_free() # Frees the data scene from parent scene and program memory
