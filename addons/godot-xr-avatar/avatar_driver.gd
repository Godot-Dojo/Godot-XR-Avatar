@tool
class_name XRAvatarDriver
extends Node


## Get the avatar driver state
func get_avatar_driver_state() -> XRAvatarDriverState:
	push_error("Only implementations of XRAvatarDriver should be used")
	breakpoint
	return null
