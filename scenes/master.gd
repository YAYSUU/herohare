# a basic scene loader that holds a main scene as
# well as multiple overlay scenes

extends Control

var main_scene_container
var overlay_scene_container

var current_scene
var overlay_scenes = []
	
func unload_current_scene() -> void:
	if not current_scene:
		push_warning("Master: no scene to unload!")
		return
	
	main_scene_container.remove_child(current_scene)
	current_scene = null

func load_scene(path: String) -> void:
	if current_scene:
		unload_current_scene()
	
	var resource: PackedScene = load(path)
	assert(resource != null)
	assert(resource.can_instantiate())
	var instance = resource.instantiate()
	current_scene = instance
	main_scene_container.add_child(instance)

func unload_overlay_scene(index: int) -> void:
	assert(index > 0 and index < len(overlay_scenes) - 1)
	overlay_scene_container.remove_child(overlay_scenes[index])
	overlay_scenes.remove_at(index)

func load_overlay_scene(path: String) -> int:
	var resource: PackedScene = load(path)
	assert(resource != null)
	assert(resource.can_instantiate())
	var instance = resource.instantiate()
	overlay_scenes.push_back(instance)
	overlay_scene_container.add_child(instance)
	return len(overlay_scenes) - 1

func _ready() -> void:
	main_scene_container = Control.new()
	overlay_scene_container = Control.new()
	
	add_child(main_scene_container)
	add_child(overlay_scene_container)

func _draw() -> void:
	if not current_scene:
		# just something to fill the void
		draw_rect(get_viewport_rect(), Color.RED, false, 8, false)
