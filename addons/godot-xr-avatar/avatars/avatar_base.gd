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


## Set the sychronization visibility for this node to the specified network peer.
func set_visibility_for(p_peer : int, p_visible : bool) -> void:
	$MultiplayerSynchronizer.set_visibility_for(p_peer, p_visible)
