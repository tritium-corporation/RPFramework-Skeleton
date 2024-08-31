/obj/effect/phone_line
	name = "Phone line"
	desc = "A... huh.. I won't even comment on that.."
	anchored = TRUE
	plane = ABOVE_TURF_PLANE
	layer = BELOW_DOOR_LAYER
	icon = 'code/modules/keybindlibrary/phone/icon/phones.dmi'
	icon_state = "phonelinetape"

/obj/effect/phone_line/New()
	dir = pick(GLOB.cardinal)
	..()