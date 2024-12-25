
/area/roleplay
	music = 'sound/music/trench_bgm.ogg'
	dynamic_lighting = TRUE
	requires_power = FALSE
	//turf_initializer = /decl/turf_initializer/oldfare

/* // An example of screen overlays
/area/roleplay/Entered(mob/living/L, area/A)
	. = ..()

	if(istype(L) && !istype(A, /area/roleplay/))//Doesn't work but this does stop the lag.
		L.overlay_fullscreen("fog", /obj/screen/fullscreen/fog)
		L.overlay_fullscreen("ash", /obj/screen/fullscreen/storm)
		L.overlay_fullscreen("ashparticle", /obj/screen/fullscreen/ashparticles)

	if(istype(L) && !istype(A, /area/roleplay/))
		L.clear_fullscreen("fog")
		L.clear_fullscreen("ash")
		L.clear_fullscreen("ashparticle")
*/
/* // Warfare example of creating an area that is shot at by mortars

/area/warfare/battlefield/no_mans_land
	name = "\improper No Man\'s Land"

	New()
		..()
		GLOB.mortar_areas += src
*/