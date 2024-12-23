
/datum/map/roleplay
	name = "Coldfare"
	full_name = "Roleplay"
	path = "roleplay"
	station_name  = "ROLEPLAY"
	station_short = "ROLEPLAY"
	dock_name     = "ROLEPLAY"
	boss_name     = "BOSS FULL NAME"
	boss_short    = "BOSS"
	company_name  = "BASE"
	company_short = "B.A.S.E"
	system_name = "hell" // SS13 space thing

	lobby_icon = 'maps/rpf_base/fullscreen.dmi'
	lobby_screens = list("lobby")

	station_levels = list(1,2)
	contact_levels = list(1)
	player_levels = list(1,2)

	allowed_spawns = list("Arrivals Shuttle")
	base_turf_by_z = list("1" = /turf/unsimulated/floor/hammereditor/dev1)
	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"
	map_lore = "MAP LORE."

/*
/datum/map/warfare/perform_map_generation()
	var/list/z_levels = list(1) //,2)
	var/list/templates = list(/datum/map_template/ruin/exoplanet/randbuilding1, /datum/map_template/ruin/exoplanet/randbuilding2, /datum/map_template/ruin/exoplanet/randbuilding3)

	do_small_ruin_generation(z_levels, templates, 5)
	//do_small_ruin_generation(list(1), list(/datum/map_template/ruin/exoplanet/smugglers_den), 1)
	//do_small_ruin_generation(list(1), list(/datum/map_template/ruin/exoplanet/crashed_ship), 1)
	//do_small_ruin_generation(list(1), list(/datum/map_template/ruin/exoplanet/bunker), 1)
	return 1
*/


//Overriding event containers to remove random events.
/datum/event_container/mundane
	available_events = list(
		/*
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars1",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars2",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars3",/datum/event/mortar,100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mortars4",/datum/event/mortar,100)
		*/
		)

/datum/event_container/moderate
	available_events = list(
	)

/datum/event_container/major
	available_events = list(
	)