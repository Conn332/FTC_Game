local background = {}

function background:new(name,player,xoff,yoff)
	xoff = xoff or 0
	yoff = yof or 0
	local o = {
		["bg"] = love.graphics.newImage(name),
		["player"] = player,
		["xoff"] = xoff,
		["yoff"] = yoff
	}

	setmetatable(o, self)
	self.__index = self

	return o
end

function background:update(dt)

end

function background:draw()
	love.graphics.draw(self.bg,self.xoff-self.player.x,self.yoff-self.player.y)
end

return background