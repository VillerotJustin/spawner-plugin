@tool
extends EditorPlugin

const PLUGIN_NAME = "Spawner"

func _enable_plugin() -> void:
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/spawner_2d", true)
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/spawner_3d", true)


func _disable_plugin() -> void:
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/spawner_2d", false)
	EditorInterface.set_plugin_enabled(PLUGIN_NAME + "/spawner_3d", false)


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
