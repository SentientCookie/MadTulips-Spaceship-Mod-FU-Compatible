local textureSelected = 2;

function init()
	entity.setInteractive(entity.configParameter("interactive", true))
end

function uninit()

end

function onInboundNodeChange(args)
  if args.level then
    textureSelected = (textureSelected + 1)
  end
end

function onInteraction(args)
	textureSelected = (textureSelected + 1)
end

function update(dt)
	if(textureSelected == 1) then entity.setAnimationState("textureState", "low") end
	if(textureSelected == 2) then entity.setAnimationState("textureState", "med") end
	if(textureSelected == 3) then entity.setAnimationState("textureState", "high") end
	if(textureSelected > 3) then textureSelected = 1 end
end