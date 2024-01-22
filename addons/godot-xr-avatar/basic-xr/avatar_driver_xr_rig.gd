@tool
class_name XRAvatarDriverXRRig
extends XRAvatarDriver


## XR-Avatar Driver for Basic XR Rigs
##
## This script drive an avatar from a basic XR Rig.


## XR Rig Origin
@export var origin : XROrigin3D : set = _set_origin

## XR Rig Camera
@export var camera : XRCamera3D : set = _set_camera

## XR Rig Left Controller
@export var left_controller : XRController3D : set = _set_left_controller

## XR Rig Right Controller
@export var right_controller : XRController3D : set = _set_right_controller


# Current driver state
var _state : XRAvatarDriverState = XRAvatarDriverState.new()

# Last ground position
var _ground_last : Vector3 = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	# Do not initialize if in the editor
	if Engine.is_editor_hint():
		set_physics_process(false)
		return

	# Set physics priority
	process_physics_priority = -95


# Get the configuration warnings for this node.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	# Check the mandatory nodes
	if not origin:
		warnings.append("Origin must be set")
	if not camera:
		warnings.append("Camera must be set")
	if not left_controller:
		warnings.append("Left controller must be set")
	if not right_controller:
		warnings.append("Right controller must be set")

	# Return warnings
	return warnings


# Update the avatar
func _physics_process(_delta : float) -> void:
	# Calculate the ground transform
	var player_xform := origin.global_transform
	player_xform.origin += camera.position.slide(Vector3.UP)
	var player_xform_inv := player_xform.inverse()

	# Get the ground position and velocity
	var ground_pos := player_xform.origin
	var ground_vel := origin.to_local(ground_pos - _ground_last).slide(Vector3.UP) / _delta
	var ground_vel2 := Vector2(ground_vel.x, -ground_vel.z)
	_ground_last = ground_pos

	# Update the avatar state
	_state.player_transform = player_xform
	_state.head_transform = player_xform_inv * camera.global_transform
	_state.left_hand_transform = player_xform_inv * left_controller.global_transform
	_state.right_hand_transform = player_xform_inv * right_controller.global_transform
	_state.ground_control = ground_vel2


func get_avatar_driver_state() -> XRAvatarDriverState:
	return _state


func _set_origin(p_origin : XROrigin3D) -> void:
	origin = p_origin
	update_configuration_warnings()


func _set_camera(p_camera : XRCamera3D) -> void:
	camera = p_camera
	update_configuration_warnings()


func _set_left_controller(p_left_controller : XRController3D) -> void:
	left_controller = p_left_controller
	update_configuration_warnings()


func _set_right_controller(p_right_controller : XRController3D) -> void:
	right_controller = p_right_controller
	update_configuration_warnings()
