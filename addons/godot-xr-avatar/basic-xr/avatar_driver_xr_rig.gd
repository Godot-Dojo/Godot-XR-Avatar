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


# Last ground position
var _ground_last : Vector3 = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	super()

	# Do not initialize if in the editor
	if Engine.is_editor_hint():
		set_physics_process(false)
		return

	# Set physics priority
	process_physics_priority = -100


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
	if not is_instance_valid(_current_avatar):
		return

	# Calculate the ground transform
	var ground_xform := origin.global_transform
	ground_xform.origin += camera.position.slide(Vector3.UP)

	# Get the ground position and velocity
	var ground_pos := ground_xform.origin
	var ground_vel := origin.to_local(ground_pos - _ground_last).slide(Vector3.UP) / _delta
	var ground_vel2 := Vector2(ground_vel.x, -ground_vel.z)
	_ground_last = ground_pos

	# Update the current avatar
	_current_avatar.global_transform = ground_xform
	_current_avatar.head_target.global_transform = camera.global_transform
	_current_avatar.left_hand_target.global_transform = left_controller.global_transform
	_current_avatar.right_hand_target.global_transform = right_controller.global_transform
	_current_avatar.ground_control = ground_vel2


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
