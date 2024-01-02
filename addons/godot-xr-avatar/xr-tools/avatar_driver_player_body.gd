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


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRAvatarDriverPlayerBody"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

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
func _physics_process(_delta : float) -> void:
	if not is_instance_valid(_current_avatar):
		return

	# Update the current avatar
	_current_avatar.global_transform = _body.global_transform
	_current_avatar.head_target.global_transform = _camera.global_transform
	_current_avatar.left_hand_target.global_transform = _left_controller.global_transform
	_current_avatar.right_hand_target.global_transform = _right_controller.global_transform
	_current_avatar.ground_control = _body.ground_control_velocity


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
