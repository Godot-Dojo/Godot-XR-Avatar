@tool
class_name XRAvatarDriver
extends Node


## XR Avatar to drive
@export var avatar : XRAvatarBase : set = _set_avatar


# Current avatar being driven
var _current_avatar : XRAvatarBase


# Called when the node enters the scene tree for the first time.
func _ready():
	# Do not initialize if in the editor
	if Engine.is_editor_hint():
		set_physics_process(false)
		return

	# Update the avatar
	_update_avatar()


func _set_avatar(p_avatar : XRAvatarBase) -> void:
	avatar = p_avatar
	if is_inside_tree():
		_update_avatar()


func _update_avatar() -> void:
	# Stop wearing old avatar
	if is_instance_valid(_current_avatar):
		_current_avatar.locally_driven = false

	# Wear the new avatar
	_current_avatar = avatar
	if is_instance_valid(_current_avatar):
		_current_avatar.locally_driven = true
