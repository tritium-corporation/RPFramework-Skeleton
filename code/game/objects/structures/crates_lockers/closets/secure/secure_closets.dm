/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's a card-locked storage unit."

	setup = CLOSET_HAS_LOCK | CLOSET_CAN_BE_WELDED
	locked = TRUE

	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_off = "secureoff"

	icon_opened = "secureopen"

	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200

/obj/structure/closet/secure_closet/slice_into_parts(obj/item/weldingtool/WT, mob/user)
	to_chat(user, "<span class='notice'>\The [src] is too strong to be taken apart.</span>")

/obj/structure/closet/secure_closet/warfare
	icon_state = "intermetal"
	icon_closed = "intermetal"
	icon_opened = "intermetalopen"
	icon_off = ""
	icon_locked = ""
	open_sound = 'sound/effects/locker_open1.ogg'
	close_sound = 'sound/effects/locker_close1.ogg'
	setup = 0
	locked = FALSE
	req_access = list()

/obj/structure/closet/secure_closet/warfare/newver
	icon_state = "intermetalnew"
	icon_closed = "intermetalnew"
	icon_opened = "intermetalnewopen"
	icon_off = ""
	icon_locked = ""
	open_sound = 'sound/effects/locker_open1.ogg'
	close_sound = 'sound/effects/locker_close1.ogg'
	setup = 0
	locked = FALSE
	req_access = list()

/obj/structure/closet/secure_closet/warfare/practicioner
	icon_state = "prac"
	icon_closed = "prac"
	icon_opened = "pracopen"
	icon_off = ""
	icon_locked = ""
	open_sound = 'sound/effects/lockerbig_open1.ogg'
	close_sound = 'sound/effects/lockerbig_close1.ogg'
	setup = 0
	locked = FALSE
	req_access = list()