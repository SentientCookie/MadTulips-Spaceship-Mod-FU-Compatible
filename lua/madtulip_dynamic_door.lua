function init(args)
	self.anchor = config.getParameter("anchors")[1]
	setupMaterialSpaces()
  -- no direction up/down implemented
  -- setDirection(storage.doorDirection or object.direction())

	if storage.locked == nil then
		storage.locked = config.getParameter("locked", false)
	end
 
	if storage.state == nil then
		if config.getParameter("defaultState") == "open" then
			openDoor()
		else
			closeDoor()
		end
	else
    -- animator.setAnimationState("doorState", storage.state and "open" or "closed")
		if self.anchor == "left" or self.anchor == "right" then
			animator.setAnimationState("doorState", "close" .. "Floor")
		else
			animator.setAnimationState("doorState", "close" .. "Wall")
		end
	end
  

	updateInteractive()
	updateCollisionAndWires()
	updateLight()

	message.setHandler("openDoor", function() openDoor() end)
	message.setHandler("lockDoor", function() lockDoor() end)
end

function onNodeConnectionChange(args)
  updateInteractive()
  if object.isInputNodeConnected(0) then
    onInputNodeChange({ level = object.getInputNodeLevel(0) })
  end
end

function onInputNodeChange(args)
  if args.level then
    openDoor(storage.doorDirection)
  else
    closeDoor()
  end
end

function onInteraction(args)
  if storage.locked then
    animator.playSound("locked")
  else
    if not storage.state then
      openDoor(args.source[1])
    else
      closeDoor()
    end
  end
end

function updateLight()
  if not storage.state then
    object.setLightColor(config.getParameter("closedLight", {0,0,0,0}))
  else
    object.setLightColor(config.getParameter("openLight", {0,0,0,0}))
  end
end

function updateInteractive()
  object.setInteractive(config.getParameter("interactive", true) and not object.isInputNodeConnected(0))
end

function updateCollisionAndWires()
  object.setMaterialSpaces(storage.state and self.openMaterialSpaces or self.closedMaterialSpaces)
  object.setAllOutputNodes(storage.state)
end

function setupMaterialSpaces()
  self.closedMaterialSpaces = config.getParameter("closedMaterialSpaces")
  if not self.closedMaterialSpaces then
    self.closedMaterialSpaces = {}
    for i, space in ipairs(object.spaces()) do
      table.insert(self.closedMaterialSpaces, {space, "metamaterial:door"})
    end
  end
  self.openMaterialSpaces = config.getParameter("openMaterialSpaces", {})
end

--[[
function setDirection(direction)
  storage.doorDirection = direction
  animator.setGlobalTag("doorDirection", direction < 0 and "Left" or "Right")
end
--]]

function hasCapability(capability)
  if capability == 'lockedDoor' then
    return storage.locked
  elseif object.isInputNodeConnected(0) or storage.locked then
    return false
  elseif capability == 'door' then
    return true
  elseif capability == 'closedDoor' then
    return not storage.state
  elseif capability == 'openDoor' then
    return storage.state
  else
    return false
  end
end

function doorOccupiesSpace(position)
  local relative = {position[1] - object.position()[1], position[2] - object.position()[2]}
  for _, space in ipairs(object.spaces()) do
    if math.floor(relative[1]) == space[1] and math.floor(relative[2]) == space[2] then
      return true
    end
  end
  return false
end

--[[
function lockDoor()
  if not storage.locked then
    storage.locked = true
    updateInteractive()
    if storage.state then
      -- close door before locking
      storage.state = false
      animator.playSound("close")
      animator.setAnimationState("doorState", "locking")
      updateCollisionAndWires()
    else
      animator.setAnimationState("doorState", "locked")
    end
    return true
  end
end

function unlockDoor()
  if storage.locked then
    storage.locked = false
    updateInteractive()
    animator.setAnimationState("doorState", "closed")
    return true
  end
end
--]]

function closeDoor()
  if storage.state ~= false then
    storage.state = false
    animator.playSound("closeSounds")
	
	if self.anchor == "left" or self.anchor == "right" then
		animator.setAnimationState("doorState", "close" .. "Floor")
	else
		animator.setAnimationState("doorState", "close" .. "Wall")
	end

    updateCollisionAndWires()
    updateLight()
  end
end

function openDoor(direction)
  if not storage.state then
    storage.state = true
    storage.locked = false -- make sure we don't get out of sync when wired
    --setDirection((direction == nil or direction * object.direction() < 0) and -1 or 1)
    animator.playSound("openSounds")
	
	if self.anchor == "left" or self.anchor == "right" then
		animator.setAnimationState("doorState", "open" .. "Floor")
	else
		animator.setAnimationState("doorState", "open" .. "Wall")
	end
	
    updateCollisionAndWires()
    updateLight()
  end
end
