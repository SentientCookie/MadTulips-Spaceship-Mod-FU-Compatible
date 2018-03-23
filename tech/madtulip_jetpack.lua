require "/scripts/vec2.lua"
require "/lua/madtulip_is_shipworld.lua"
require "/lua/madtulip_is_in_space.lua"

function init()
	self.boostVelocity = {0, 0}
	self.boostPower = config.getParameter("boostPower")
	self.We_are_in_ZERO_gravity = false

	idle()
end

function uninit()
	idle()
end

function update(args)
	-- check for exit conditions
	if not can_use_jetpack() then
		idle()
		return
	end
	
	-- process keyboard input
	local direction = {0, 0}
	if args.moves["right"] then direction[1] = direction[1] + 1 end
	if args.moves["left"] then direction[1] = direction[1] - 1 end
	if args.moves["up"] then direction[2] = direction[2] + 1 end
	if args.moves["down"] then direction[2] = direction[2] - 1 end
	
	-- hard break by pressing jump - not sure if we should remove this
	--if args.moves["jump"] then mcontroller.setVelocity({0, 0}) end

	-- if movement was performed
	if vec2.eq(direction, {0, 0}) then
		-- is idle
		idle()
	else
		-- is boosting
		boost()
		-- setup force vector
		self.boostForce = vec2.mul(vec2.norm(direction), self.boostPower)
		mcontroller.controlForce(self.boostForce)
	end

	-- flip the animation if required (facing of player)
	animator.setFlipped(mcontroller.facingDirection() < 0)
end

function can_use_jetpack()
	if (self.We_are_in_ZERO_gravity) then
		-- try to get out of "space"
		self.We_are_in_ZERO_gravity = not determine_if_in_space_condition_should_end(3)
		
	else
		-- try to get into "space"
		self.We_are_in_ZERO_gravity = determine_if_in_space_condition_should_start(4)
	end

	return is_shipworld()
		and self.We_are_in_ZERO_gravity
		and not mcontroller.liquidMovement()
end

function boost()
  status.setPersistentEffects("movementAbility", {{stat = "activeMovementAbilities", amount = 1}})
  animator.setParticleEmitterActive("rocketParticles", true)
  animator.playSound("boost")
end

function idle()
  status.clearPersistentEffects("movementAbility")
  animator.setParticleEmitterActive("rocketParticles", false)
  animator.stopAllSounds("boost")
end
