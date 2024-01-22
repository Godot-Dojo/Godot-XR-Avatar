@tool
class_name XRAvatarBase
extends Node3D


## XR-Avatar Avatar Base Script
##
## This script implements the base functionality required for all types of
## avatars


enum PositionMode {
	FULL,
	ROTATION,
	NONE
}


## Array of SkeletonIK3D to auto-start
@export var auto_start_ik : Array[SkeletonIK3D] = []

## Face meshes to hide from local player when worn
@export var face_meshes : Array[MeshInstance3D] = []

## Current avatar driver
@export var driver : XRAvatarDriver : set = _set_driver

## Position mode
@export var position_mode : PositionMode = PositionMode.FULL : set = _set_position_mode


## Ground control velocity
var _ground_control : Vector2


## Node set to the players head tracker
@onready var _head_target : Marker3D = $Head

## Node set to the players left-hand tracker
@onready var _left_hand_target : Marker3D = $LeftHand

## Node set to the players right-hand tracker
@onready var _right_hand_target : Marker3D = $RightHand


func _ready() -> void:
	# Set physics priority
	process_physics_priority = -95

	# Start the auto-start skeleton IKs
	for ik in auto_start_ik:
		ik.start()

	# Dispatch the worn state
	_dispatch_worn()


# Update the avatar
func _physics_process(_delta : float) -> void:
	# Skip if no avatar driver
	if not is_instance_valid(driver):
		return

	# Get the driver state
	var state := driver.get_avatar_driver_state()
	if not state:
		return

	# Position the avatar
	match position_mode:
		PositionMode.FULL:
			global_transform = state.player_transform

		PositionMode.ROTATION:
			global_basis = state.player_transform.basis

	# Pose the avatar
	_head_target.transform = state.head_transform
	_left_hand_target.transform = state.left_hand_transform
	_right_hand_target.transform = state.right_hand_transform
	_ground_control = state.ground_control


## Set the sychronization visibility for this node to the specified network peer.
func set_visibility_for(p_peer : int, p_visible : bool) -> void:
	$MultiplayerSynchronizer.set_visibility_for(p_peer, p_visible)


# Handle changes to driver
func _set_driver(p_driver : XRAvatarDriver) -> void:
	driver = p_driver
	if is_inside_tree():
		_dispatch_worn()


func _set_position_mode(p_position_mode : PositionMode) -> void:
	position_mode = p_position_mode
	if is_inside_tree():
		_dispatch_worn()


# Dispatch change of worn state
func _dispatch_worn() -> void:
	# Test if avatar is worn
	var worn := driver and position_mode == PositionMode.FULL

	# Dispatch worn state
	_update_worn(worn)


# Update model based on whether its worn
func _update_worn(p_worn : bool) -> void:
	# Switch face-meshes to layer 2 when worn
	for m in face_meshes:
		m.layers = 2 if p_worn else 1
