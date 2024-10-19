/atom/proc/getMovementSound(var/turf/turf)
	return null

/obj/structure/closet/getMovementSound(turf)
	if(istype(turf, /turf/simulated/floor/concrete) && !locate(/obj/structure/table) in turf || istype(turf, /turf/simulated/floor/wood) && !locate(/obj/structure/table) in turf)
		return 'sound/effects/metalconcrete1.ogg'
	return null

/obj/structure/closet/crate/getMovementSound(turf)
	if(istype(turf, /turf/simulated/floor/concrete) && !locate(/obj/structure/table) in turf || istype(turf, /turf/simulated/floor/wood) && !locate(/obj/structure/table) in turf)
		return 'sound/effects/metalconcrete3.ogg'
	return null

/obj/structure/closet/
	mouse_drag_pointer = TRUE