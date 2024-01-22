class_name MultiplayerSceneBase
extends XRToolsSceneBase


## XR-Avatar Multiplayer Scene Base Script
##
## This script extends [XRToolsSceneBase] to provide a scene capable of hosting
## multiple network players. The multiplayer peer must be established in a lobby
## before switching to this scene.


# Local avatar
var _avatar : XRAvatarBase

# Dictionary of peers to avatars
var _peers := {}


# Called when this scene is loaded
func scene_loaded(user_data = null):
	super(user_data)

	# Subscribe to peer disconnection to remove stale peers/avatars
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	# Create the local avatar
	_avatar = _add_avatar(multiplayer.get_unique_id())

	# Inform the server we are entering the zone
	_peer_entering_zone.rpc_id(1, multiplayer.get_unique_id())


# Called when we start to exit this scene
func scene_pre_exiting(user_data = null):
	super(user_data)

	# Suspend synchronization to all current peers
	if _avatar:
		for p in _peers:
			_avatar.set_visibility_for(p, false)

	# Inform the server this peer is leaving the zone
	_peer_exiting_zone.rpc_id(1, multiplayer.get_unique_id())


# Called on the server by a peer when it starts entering this zone
@rpc("any_peer", "call_local", "reliable")
func _peer_entering_zone(p_peer : int) -> void:
	# Notify the new peer of existing peers
	if p_peer != 1:
		_peers_in_zone.rpc_id(p_peer, _peers.keys())

	# Notify current peers of the new arival
	for p in _peers:
		_peer_entered_zone.rpc_id(p, p_peer)


# Called on a new peer by the server with the list of current peers in this zone
@rpc("authority", "call_remote", "reliable")
func _peers_in_zone(p_peers_in_zone) -> void:
	# Create avatars for all peers and show our avatar to them
	for p : int in p_peers_in_zone:
		_add_avatar(p)
		_avatar.set_visibility_for(p, true)


# Called on all peers in this zone informing them when a new peer enters
@rpc("authority", "call_local", "reliable")
func _peer_entered_zone(p_peer : int) -> void:
	# Enable local avatar to be visible to the peer
	if p_peer != multiplayer.get_unique_id():
		_avatar.set_visibility_for(p_peer, true)

	# Add an avatar for the new peer
	_add_avatar(p_peer)


# Called on the server by a peer when it starts exiting this zone
@rpc("any_peer", "call_local", "reliable")
func _peer_exiting_zone(p_peer : int) -> void:
	# Notify current peers of the new arival
	for p in _peers:
		_peer_exited_zone.rpc_id(p, p_peer)


# Called on all peers in this zone when a peer exits the zone
@rpc("authority", "call_local", "reliable")
func _peer_exited_zone(p_peer : int) -> void:
	# Disable avatar reporting to the peer
	_avatar.set_visibility_for(p_peer, false)

	# Remove the peers avatar
	_remove_avatar(p_peer)


# Called when a peer disconnect
func _on_peer_disconnected(p_peer : int) -> void:
	# Skip if peer not in this zone
	if not _peers.has(p_peer):
		return

	# Disable avatar reporting to the peer
	_avatar.set_visibility_for(p_peer, false)

	# Remove the peers avatar
	_remove_avatar(p_peer)


# Add an avatar for the peer to this zone
func _add_avatar(p_peer : int) -> XRAvatarBase:
	# Check for an existing instance
	var inst : XRAvatarBase = $Avatars.get_node_or_null(str(p_peer))
	if inst:
		return inst

	# Create the avatar
	inst = _create_avatar(p_peer)
	inst.name = str(p_peer)
	inst.set_multiplayer_authority(p_peer)
	$Avatars.add_child(inst)
	_peers[p_peer] = inst

	# If this avatar is local then set it as the player body avatar
	if inst.is_multiplayer_authority():
		inst.driver = $XROrigin3D/AvatarDriverPlayerBody

	# Return the avatar
	return inst


# Remove a peers avatar from this zone
func _remove_avatar(p_peer : int) -> void:
	# Check for an existing instance
	var inst : XRAvatarBase = _peers.get(p_peer)
	if inst:
		_peers.erase(p_peer)
		inst.queue_free()


# Create an avatar for the peer (override in scene)
func _create_avatar(_peer : int) -> XRAvatarBase:
	return null
