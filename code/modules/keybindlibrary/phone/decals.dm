/obj/effect/phone_line
	name = "Phone line"
	desc = "Who would even talk to each other here?"
	anchored = TRUE
	plane = ABOVE_TURF_PLANE
	layer = BELOW_DOOR_LAYER
	icon = 'code/modules/keybindlibrary/phone/icon/phones.dmi'
	icon_state = "phonelinetape"

/obj/effect/phone_line/New()
	dir = pick(GLOB.cardinal)
	..()