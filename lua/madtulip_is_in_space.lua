require "/lua/madtulip_is_shipworld.lua"

function determine_if_in_space_condition_should_end(Range)
	-- we assume a solid area around us unless we find a hole (no back AND foregrond block) in the area
	local solid_area_around_us = true;
	local Origin = mcontroller.position();
	for cur_X = -Range, Range, 1 do
		for cur_Y = -Range, Range, 1 do
			local cur_abs_Position = {};
			cur_abs_Position[1] = Origin[1] + cur_X;
			cur_abs_Position[2] = Origin[2] + cur_Y;
				if ((world.material(cur_abs_Position, "foreground") == false) and (world.material(cur_abs_Position, "background") == false)) then
					solid_area_around_us = false;
			end
		end	
	end
	
	-- check if theres floor under us so we can land on the spaceship roof
	local Blocks_under_us = true;
	local Origin = mcontroller.position();
	for cur_X = -1, 1, 1 do
		local cur_abs_Position = {};
		cur_abs_Position[1] = Origin[1] + cur_X;
		cur_abs_Position[2] = Origin[2] -3;
		if world.material(cur_abs_Position, "foreground") == false then
			Blocks_under_us = false;
		end
	end

	-- if theres eigther floor under us or we are inside (solid blocks around us) we want to end ZERO G movement
	local Zero_gravity_ends = solid_area_around_us or Blocks_under_us
	
	return Zero_gravity_ends;
end

function determine_if_in_space_condition_should_start(Range)
	-- return if we are on a planet
	if not is_shipworld() then return false end
	
	-- we assume Zero gravity unless we find blocks in the vicinity
	local Zero_gravity_starts = true;
	local Origin = mcontroller.position();
	for cur_X = -Range, Range, 1 do
		for cur_Y = -Range, Range, 1 do
			local cur_abs_Position = {};
			cur_abs_Position[1] = Origin[1] + cur_X;
			cur_abs_Position[2] = Origin[2] + cur_Y;
			
			if not((world.material(cur_abs_Position, "foreground") == false) and (world.material(cur_abs_Position, "background") == false)) then
				Zero_gravity_starts = false;
			end
		end	
	end
	
	-- if theres only emptyness around us we are using ZERO G movement
	return Zero_gravity_starts;
end