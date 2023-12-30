@tool
class_name XRToolsPlayerBodyAvatar
extends Node


## XR-Avatar Player Body Avatar Script
##
## This script works in conjunction with an [XRToolsPlayerBody] to drive/wear
## the selected avatar.


## Avatar to drive/wear
@export var avatar : XRAvatarBase : set = _set_avatar


var _body : XRToolsPlayerBody

var _camera : XRCamera3D

var _left_controller : XRController3D

var _right_controller : XRController3D

var _current_avatar : XRAvatarBase


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRToolsPlayerBodyAvatar"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Do not initialize if in the editor
	if Engine.is_editor_hint():
		set_physics_process(false)
		return

	# Set physics priority
	process_physics_priority = -100

	# Get the XR nodes
	_body = XRToolsPlayerBody.find_instance(self)
	_camera = XRHelpers.get_xr_camera(self)
	_left_controller = XRHelpers.get_left_controller(self)
	_right_controller = XRHelpers.get_right_controller(self)

	# Update the avatar
	_update_avatar()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta : float) -> void:
	if not is_instance_valid(_current_avatar):
		return

	# Update the current avatar
	_current_avatar.global_transform = _body.global_transform
	_current_avatar.head_target.global_transform = _camera.global_transform
	_current_avatar.left_hand_target.global_transform = _left_controller.global_transform
	_current_avatar.right_hand_target.global_transform = _right_controller.global_transform


func _set_avatar(p_avatar : XRAvatarBase) -> void:
	# Save the avatar and update if inside tree
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


## Find an [XRToolsPlayerBodyAvatar] node.
##
## This function searches from the specified node for an
## [XRToolsPlayerBodyAvatar] assuming the node is a sibling of the body under
## an [XROrigin3D].
static func find_instance(node: Node) -> XRToolsPlayerBodyAvatar:
	return XRTools.find_xr_child(
		XRHelpers.get_xr_origin(node),
		"*",
		"XRToolsPlayerBodyAvatar") as XRToolsPlayerBodyAvatar
