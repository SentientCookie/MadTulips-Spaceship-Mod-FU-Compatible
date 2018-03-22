function init()
	-- Make our object interactive (we can interract by 'Use')
	object.setInteractive(true)
end	

function onInteraction(args)

	if not is_shipworld() then return 1 end
	
	-- YES! :) HIT!
	-- interactData = config.getParameter("interactData");
	-- return {"OpenTeleportDialog",interactData}
	
	return { "OpenTeleportDialog", {
        canBookmark = false,
		includePartyMembers = true,
        includePlayerBookmarks = true,
        destinations = { {
          name = "Beam Down",
          planetName = "current orbited world",
          icon = "beamdown",
          warpAction = "OrbitedWorld"
        } }
      }
    }
end