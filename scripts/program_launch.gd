extends Node

func _ready() -> void:
	await get_tree().create_timer(.05).timeout
	get_tree().change_scene_to_file("res://scenes/node_environment.tscn")
