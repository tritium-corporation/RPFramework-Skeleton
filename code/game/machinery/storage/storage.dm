/* Copyright (C) The interbay dev team - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 *
 * Proprietary and confidential
 * Do not modify or remove this header.
 *
 * Written by Kyrah Abattoir <git@kyrahabattoir.com>, August 2018
 */

//This is a special baseclass to equip machineries and other static objects with
//a standard backpack style storage, it does so by overriding the adjacency check
//allowing to manipulate the container's inventory despite not being on a player
//or a turf.


// TWOFARE NOTE: Rewrite some of this it's hot garbage

/obj/item/storage/special
	name = "/obj/item/storage/special"
	desc = "base storage for storage machines & structures"
	w_class = ITEM_SIZE_NO_CONTAINER
	max_w_class = ITEM_SIZE_GARGANTUAN //you prolly want to change this on subclasses.
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	var/closed_state
	var/open_state
	//storage_slots = 1
	use_sound = null
	close_sound = null
	var/isopen = FALSE
	var/atom/holder
	var/usestates

// // all of this is so hacky that I wouldn't be suprised if we reverted this someday
///obj/item/storage/special/on_open()
//	..()
//	if(!isopen)
//		isopen = TRUE
//		if(usestates)
//			holder.icon_state = open_state
//		return
//
///obj/item/storage/special/on_close()
//	..()
//	if(isopen)
//		isopen = FALSE
//		if(usestates)
//			holder.icon_state = closed_state
//		return
//
///obj/item/storage/special/quick_insert()
//	..()
//	if(!isopen)
//		isopen = TRUE
//		if(usestates)
//			holder.icon_state = open_state
//		spawn(0.5 SECONDS)
//			if(usestates)
//				holder.icon_state = closed_state
//			isopen = FALSE
//	return

//overrides item:Adjacent() so we can drop down one level
/obj/item/storage/special/Adjacent(var/atom/neighbor)
	return loc.Adjacent(neighbor)

/obj/item/storage/special/attack_hand(mob/user as mob)
	open(user)

/obj/item/storage/special/AltClick(mob/user as mob)
	open(user)

/obj/item/storage/special/gather_all(var/turf/T)
	for(var/obj/item/I in T)
		if(can_be_inserted(I, null, 1))
			handle_item_insertion(I, 1, 1) // First 1 is no messages, second 1 is no ui updates
		else
			continue

//Use this machine as a base class it's pretty simple
/obj/machinery/storage/
	name = "/obj/machinery/storage/"
	desc = "baseclass for storage enabled machines"
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	var/open_state
	var/closed_state
	var/obj/item/storage/special/inventory
	var/usestates = TRUE

/obj/machinery/storage/New()
	inventory = new /obj/item/storage/special()
	inventory.holder = src
	inventory.loc = src   //VERY IMPORTANT
	inventory.name = name //Not strictly needed but this affects the text description when players insert items inside the storage.
	inventory.usestates = usestates
	if(closed_state)
		inventory.closed_state = closed_state
	else if(!closed_state)
		inventory.closed_state = icon_state
	if(open_state)
		inventory.open_state = open_state
	else if(!open_state)
		inventory.open_state = icon_state

/obj/machinery/storage/Destroy()
	qdel(inventory)
	..()

//fowards attack_hand
/obj/machinery/storage/attack_hand(mob/user as mob)
	inventory.attack_hand(user)

//fowards attackby
/obj/machinery/storage/attackby(obj/item/W as obj, mob/user as mob)
	if(CanPhysicallyInteract(user))
		inventory.attackby(W, user)

/obj/machinery/storage/AltClick(mob/user as mob)
	if(CanPhysicallyInteract(user))
		inventory.open(user)


//Use this machine as a base class it's pretty simple
/obj/structure/storage/
	name = "/obj/structure/storage/"
	desc = "baseclass for storage enabled structures"
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	var/open_state
	var/closed_state
	var/obj/item/storage/special/inventory
	var/usestates

/obj/structure/storage/New()
	inventory = new /obj/item/storage/special()
	inventory.holder = src
	inventory.closed_state = src.closed_state
	inventory.open_state = src.open_state
	inventory.usestates = usestates
	inventory.loc = src   //VERY IMPORTANT
	inventory.name = name //Not strictly needed but this affects the text description when players insert items inside the storage.

/obj/structure/storage/Destroy()
	qdel(inventory)
	..()

//fowards attack_hand
/obj/structure/storage/attack_hand(mob/user as mob)
	if(CanPhysicallyInteract(user))
		inventory.attack_hand(user)

//fowards attackby
/obj/structure/storage/attackby(obj/item/W as obj, mob/user as mob)
	if(CanPhysicallyInteract(user))
		inventory.attackby(W, user)

/obj/structure/storage/AltClick(mob/user as mob)
	if(CanPhysicallyInteract(user))
		inventory.open(user)

/obj/structure/storage/cabinet
	name = "Filing cabinet"
	desc = "Dusty.. probably has the files of your great-great-great-grandfather.."
	icon = 'icons/obj/storagestructures.dmi'
	icon_state = "filing"
	anchored = TRUE
	density = TRUE
	usestates = FALSE

/obj/structure/storage/cabinet/Initialize()
	. = ..()
	inventory.max_storage_space = DEFAULT_BOX_STORAGE
	inventory.use_sound = 'sound/effects/cabinetopen.ogg'
	inventory.close_sound = 'sound/effects/cabinetclose.ogg'
	inventory.gather_all(get_turf(src))

/obj/structure/storage/cabinet/attackby(obj/item/W as obj, mob/user as mob)
	if(CanPhysicallyInteract(user))
		W.bag_place_sound = 'sound/effects/cabinetplace.ogg'
		inventory.attackby(W, user)
		W.bag_place_sound = initial(W.bag_place_sound)
