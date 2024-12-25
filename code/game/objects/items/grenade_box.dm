///OBJECT DEFINITION///
/obj/item/grenade_box
	name = "Grenade Box"
	desc = "A box used to conveniently and (relatively) safely transport grenades."
	icon = 'icons/obj/warfare.dmi'
	icon_state = "grenade_box"
	var/list/grenades = list()
	var/obj/whitelisteditem
	var/open = FALSE
	w_class = ITEM_SIZE_LARGE

///INTERACTIONS///

/obj/item/grenade_box/examine(mob/user, distance)
	. = ..()
	to_chat(user, "LEFT CLICK TO TAKE OUT WHATEVER IS INSIDE (IF OPEN) | ELSE, IF IT'S CLOSED, YOU'LL JUST PICK IT UP!\nRIGHT CLICK TO OPEN IT! ALLOWING YOU TO TAKE OUT WHATEVER IS INSIDE!")

/obj/item/grenade_box/attackby(obj/item/G as obj, mob/user as mob) //PUTTING GRENADES IN
	if(!open)
		to_chat(user,SPAN_WARNING("I can't use it when it's closed!"))

	else if(istype(G,/obj/item/grenade))
		insert_grenade(G,user)

/obj/item/grenade_box/RightClick(mob/user) //Opening and closing
	if(CanInteract(user, GLOB.physical_state))
		toggleopen()

/obj/item/grenade_box/attack_hand(mob/living/carbon/human/user)
	if(open)
		remove_grenade(user)
	else
		..()

///PROCS///

/obj/item/grenade_box/update_icon()
	. = ..()
	//Updating the sprite to reflect the amount of grenades within
	icon_state = "grenade_box_open[grenades.len]"

/obj/item/grenade_box/proc/toggleopen() //Opening and closing - the specific proc
	switch(open)
		if(TRUE)
			open = FALSE
			icon_state = "grenade_box"
		if(FALSE)
			open = TRUE
			update_icon()

/obj/item/grenade_box/proc/insert_grenade(obj/item/G as obj, mob/user as mob) //Putting in grenades
	if(!istype(G,whitelisteditem))
		to_chat(user,"The box won't fit that inside..")
	if(grenades.len >= 5)
		to_chat(user,"The box is full. I can't fit \the [G] in.")
	else
		grenades.Add(G)
		to_chat(user,SPAN_NOTICE("You put the [G.name] into the box."))
		user.drop_item(G)
		G.forceMove(src)
		update_icon()



/obj/item/grenade_box/proc/remove_grenade(mob/user as mob) //Taking out grenades
	if(!grenades.len)
		to_chat(user,SPAN_WARNING("It's empty. I can't remove nothing. What is wrong with me?"))
	else
		var/last_grenade = grenades.len
		var/removal_target = grenades[last_grenade]
		to_chat(user,SPAN_NOTICE("You remove [removal_target] from the box."))
		grenades.Remove(removal_target)
		user.put_in_hands(removal_target)
		update_icon()






/// Pre-made Grenade Boxes
// There is likley a more efficent way to do these lists. However it is 22:32 and it simply eludes me. Do tell me if said efficent method does exist. - Stuff
/obj/item/grenade_box/frags
	grenades = list(new /obj/item/grenade/frag/warfare, new /obj/item/grenade/frag/warfare, new /obj/item/grenade/frag/warfare, new /obj/item/grenade/frag/warfare, new /obj/item/grenade/frag/warfare)
	whitelisteditem = /obj/item/grenade/frag/warfare

/obj/item/grenade_box/smoke
	name = "Smoke Grenade Box"
	grenades = list(new /obj/item/grenade/smokebomb, new /obj/item/grenade/smokebomb, new /obj/item/grenade/smokebomb, new /obj/item/grenade/smokebomb, new /obj/item/grenade/smokebomb)
	whitelisteditem = /obj/item/grenade/smokebomb
