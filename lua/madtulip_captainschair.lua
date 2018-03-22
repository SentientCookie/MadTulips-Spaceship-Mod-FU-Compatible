function onInteraction(args)
	-- only works on shipworld
	if not is_shipworld() then return 1 end
	
	return { "ScriptPane", "/interface/cockpit/cockpit.config" }
end