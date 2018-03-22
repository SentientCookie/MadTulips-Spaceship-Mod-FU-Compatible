-- This function is used to overwrites parts of /objects/spawners/techstation.lua to prevent useage of techstation on none shipworlds

function onInteraction()
  if self.dialogTimer then
    sayNext()
    return nil
  else
	-- madtulip changes start
	if is_shipworld() then
		return config.getParameter("interactAction")
	else
		return nil
	end
	-- madtulip changes end
  end
end