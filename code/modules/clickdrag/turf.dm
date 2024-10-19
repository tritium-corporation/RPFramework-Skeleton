/*
/atom/
	var/drag_sound
*/ // nonono never
/turf/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob, params)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if(!get_step_towards(O, src))
		return
	if(!CanPhysicallyInteract(user))
		return
	if((istype(A) && !(A.has_gravity)) || (istype(T,/turf/space)))
		return
	if(istype(O, /obj/screen))
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return
	for (var/obj/item/grab/G in user.grabbed_by)
		if(G.stop_move())
			return
	if(istype(O, /obj/item) || istype(O, /obj/structure))
		if(params)
			var/list/mouse_control = params2list(params)
			var/p_x = 0
			var/p_y = 0
			if(mouse_control["icon-x"])
				p_x = text2num(mouse_control["icon-x"])-16
			if(mouse_control["icon-y"])
				p_y = text2num(mouse_control["icon-y"])-16

			if(get_turf(O) != get_turf(src))
				step_towards(O, src)
			var/time
			switch(isitem(O))
				if(FALSE) time = 2 SECONDS
				else time = 1 SECOND
			animate(O, time, easing = SINE_EASING, pixel_x = p_x, pixel_y = p_y)
			if(O.getMovementSound(get_turf(O)))
				playsound(get_turf(O), O.getMovementSound(get_turf(O)), 75, 0)
			if(ishuman(user) && !isitem(O))
				var/mob/living/carbon/human/H = user
				H.adjustStaminaLoss(rand(25,35))