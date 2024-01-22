@tool
class_name XRAvatarDriverPlayerBody
extends XRAvatarDriver


## XR-Avatar Driver for XR Tools Bodies
##
## This script drives an avatar using the information from an
## [XRToolsPlayerBody].


# Body to use for movement information
var _body : XRToolsPlayerBody

# Camera node
var _camera : XRCamera3D

# Left controller
var _left_controller : XRController3D

# Right controller
var _right_controller : XRController3D

# Current driver state
var _state : XRAvatarDriverState = XRAvatarDriverState.new()


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRAvatarDriverPlayerBody"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set physics priority
	process_physics_priority = -95

	# Get the XR nodes
	_body = XRToolsPlayerBody.find_instance(self)
	_camera = XRHelpers.get_xr_camera(self)
	_left_controller = XRHelpers.get_left_controller(self)
	_right_controller = XRHelpers.get_right_controller(self)


# Update the avatar
func _physics_process(_delta : float) -> void:
	var player_xform := _body.global_transform
	var player_xform_inv := player_xform.inverse()

	# Update the avatar state
	_state.player_transform = player_xform
	_state.head_transform = player_xform_inv * _camera.global_transform
	_state.left_hand_transform = player_xform_inv * _left_controller.global_transform
	_state.right_hand_transform = player_xform_inv * _right_controller.global_transform
	_state.ground_control = _body.ground_control_velocity


func get_avatar_driver_state() -> XRAvatarDriverState:
	return _state


## Find an [XRAvatarDriverPlayerBody] node.
##
## This function searches from the specified node for an
## [XRAvatarDriverPlayerBody] assuming the node is a sibling of the body under
## an [XROrigin3D].
static func find_instance(node: Node) -> XRAvatarDriverPlayerBody:
	return XRTools.find_xr_child(
		XRHelpers.get_xr_origin(node),
		"*",
		"XRAvatarDriverPlayerBody") as XRAvatarDriverPlayerBody
