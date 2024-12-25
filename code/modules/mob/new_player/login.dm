/var/obj/effect/lobby_image = new/obj/effect/lobby_image()

/var/obj/effect/wip = new/obj/effect/workinprogress()

/obj/effect/workinprogress
	name = "Interstation12"
	desc = "This shouldn't be read."
	screen_loc = "WEST,NORTH-3"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	mouse_opacity = FALSE

/obj/effect/workinprogress/Initialize()
	icon = 'icons/workinprogress.dmi'
	icon_state = "wip"
	. = ..()

/obj/effect/lobby_image
	name = "Interstation12"
	desc = "This shouldn't be read."
	screen_loc = "WEST,SOUTH"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	mouse_opacity = FALSE

/obj/effect/lobby_image/Initialize()
	icon = GLOB.using_map.lobby_icon
	var/known_icon_states = icon_states(icon)
	for(var/lobby_screen in GLOB.using_map.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			GLOB.using_map.lobby_screens -= lobby_screen

	if(GLOB.using_map.lobby_screens.len)
		icon_state = pick(GLOB.using_map.lobby_screens)
	else
		icon_state = known_icon_states[1]

	. = ..()

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")
	to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	client.screen += lobby_image
	client.screen += wip
	my_client = client
	set_sight(sight|SEE_TURFS)
	GLOB.player_list |= src
	message_admins("<span class='notice'>Login: [key], id:[computer_id], ip:[client.address]</span>")

	new_player_panel()
	if(client)
		for(var/x = 1, x < GLOB.background_music.len, x++)//Load in the songs ahead of time.
			sound_to(src, sound(GLOB.background_music[x], repeat = 1, volume = 50, wait = 0, channel = 1))
			sound_to(src, sound(null, repeat = 1, volume = 50, wait = 0, channel = 1))
	spawn(40)
		if(client)
			client.playtitlemusic()
			maybe_send_staffwarns("connected as new player")
			to_lobby( "[key] has connected.")

	if(!has_connected(ckey(client.key)))//If they've never played before show them the beginners guide.
		show_new_information()

proc/to_lobby(var/message)
	if(!message)
		return
	for(var/mob/new_player/player in GLOB.player_list)//Only the new players in the lobby get to see this.
		to_chat(player,"<b>Lobby: [message]</b>")
