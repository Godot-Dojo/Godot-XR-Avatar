@tool
class_name XRAvatarBase
extends Node3D


## XR-Avatar Avatar Base Script
##
## This script implements the base functionality required for all types of
## avatars


## Node set to the players head tracker
@export var head_target : Marker3D

## Node set to the players left-hand tracker
@export var left_hand_target : Marker3D

## Node set to the players right-hand tracker
@export var right_hand_target : Marker3D

## Array of SkeletonIK3D to auto-start
@export var auto_start_ik : Array[SkeletonIK3D] = []

## Face meshes to hide from local player when worn
@export var face_meshes : Array[MeshInstance3D] = []

## True if this avatar is being locally driven
@export var locally_driven : bool = false : set = _set_locally_driven


func _ready() -> void:
	# Start the auto-start skeleton IKs
	for ik in auto_start_ik:
		ik.start()


## Set the sychronization visibility for this node to the specified network peer.
func set_visibility_for(p_peer : int, p_visible : bool) -> void:
	$MultiplayerSynchronizer.set_visibility_for(p_peer, p_visible)


# Handle changes to locally-driven flag
func _set_locally_driven(p_locally_driven : bool) -> void:
	locally_driven = p_locally_driven

	# Set all visual layers
	if is_inside_tree():
		_update_locally_driven()


# Update model based on whether its locally driven
func _update_locally_driven() -> void:
	# Switch face-meshes to layer 2 when locally driven
	for m in face_meshes:
		m.layers = 2 if locally_driven else 1
