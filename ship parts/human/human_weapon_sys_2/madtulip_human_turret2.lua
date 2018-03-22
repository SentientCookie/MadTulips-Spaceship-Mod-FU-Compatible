function init(args)
  if not self.initialized and not args then
	  self.initialized = true
	  self.anchor = config.getParameter("anchors")[1]
  end
  object.setInteractive(false)
  if storage.state == nil then
    output(false)
  else
    object.setAllOutputNodes(storage.state)
    if storage.state then
	  if (self.anchor == "bottom") then
		animator.setAnimationState("DisplayState", "ON_Top_operation")
	  elseif (self.anchor == "top") then
	    animator.setAnimationState("DisplayState", "ON_Bottom_operation")
	  end
    else
	  if (self.anchor == "bottom") then
		animator.setAnimationState("DisplayState", "OFF_Top_operation")
	  elseif (self.anchor == "top") then
	    animator.setAnimationState("DisplayState", "OFF_Bottom_operation")
	  end
    end
  end
  self.gates = config.getParameter("gates")
  self.truthtable = config.getParameter("truthtable")
end

function output(state)
  if storage.state ~= state then
    storage.state = state
    object.setAllOutputNodes(state)
    if state then
	  if (self.anchor == "bottom") then
		animator.setAnimationState("DisplayState", "ON_Top_operation")
	  elseif (self.anchor == "top") then
	    animator.setAnimationState("DisplayState", "ON_Bottom_operation")
	  end
    else
	  if (self.anchor == "bottom") then
		animator.setAnimationState("DisplayState", "OFF_Top_operation")
	  elseif (self.anchor == "top") then
	    animator.setAnimationState("DisplayState", "OFF_Bottom_operation")
	  end
    end
  end
end

function toIndex(truth)
  if truth then
    return 2
  else
    return 1
  end
end

function update(dt)
  if self.gates == 1 then
    output(self.truthtable[toIndex(object.getInputNodeLevel(0))])
  elseif self.gates == 2 then
    output(self.truthtable[toIndex(object.getInputNodeLevel(0))][toIndex(object.getInputNodeLevel(1))])
  elseif self.gates == 3 then
    output(self.truthtable[toIndex(object.getInputNodeLevel(0))][toIndex(object.getInputNodeLevel(1))][toIndex(object.getInputNodeLevel(2))])
  end
end