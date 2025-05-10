extends Node

### Await in _ready function is needed to avoid the change_scene_to_file function
### from executing before the scene is finished loading its resources. Without it,
### _ready will throw error requesting remove_child.call_deferred. This await is best
### practice and only needed for the program_launch script. The Program scene as a 
### starting point for the program is necessary to manage launch scenes through
### script and avoid and resource loading issues caused by bootup.

func _ready() -> void:
	await get_tree().create_timer(.05).timeout
	get_tree().change_scene_to_file("res://scenes/node_environment.tscn")
