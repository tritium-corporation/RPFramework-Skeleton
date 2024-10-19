/atom/proc/getCursor(var/mob/user, var/hand)
	return 0

/obj/item/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user) && !hand)
		return 'icons/misc/interactive_cursor.dmi'
	return 0

/obj/machinery/door/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user) && !hand)
		return 'icons/misc/interactive_cursor.dmi'//'icons/misc/doorhelp_cursor.dmi'
	return 0

/obj/machinery/door/blast/getCursor(mob/user, hand)
	return 0

/obj/structure/closet/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user))
		return 'icons/misc/interactive_cursor.dmi'
		//return 'icons/misc/drop_cursor.dmi'
	return 0

/obj/structure/curtain/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user) && !hand)
		return 'icons/misc/interactive_cursor.dmi'
	return 0

/obj/machinery/vending/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user) && !hand)
		return 'icons/misc/interactive_cursor.dmi'
	return 0

/obj/item/ammo_box/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user) && istype(hand, handful_type))
		return 'icons/misc/drop_cursor.dmi'
	return . = ..()

/obj/structure/destruction_computer/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user) && !hand)
		return 'icons/misc/interactive_cursor.dmi'
	return 0

/obj/item/reagent_containers/food/snacks/warfare/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user) && istype(hand, /obj/item/material/sword/combat_knife))
		if(!is_open_container())
			return 'icons/misc/sword_cursor.dmi'
	return . = ..()

/mob/getCursor(mob/user, hand)
	if(CanPhysicallyInteract(user))
		if(user.a_intent == I_HURT)
			if(istype(hand, /obj/item/material/sword/combat_knife) || istype(hand, /obj/item/shovel))
				return 'icons/misc/sword_cursor.dmi'
			else
				return 'icons/misc/drop_cursor.dmi'
		else if(user.a_intent == I_HELP)
			if(user == src && !hand)
				return 'icons/misc/examine_cursor.dmi'
		else if(user.a_intent == I_GRAB || user.a_intent == I_DISARM)
			if(user != src && !hand)
				return 'icons/misc/interactive_cursor.dmi'
	return . = ..()