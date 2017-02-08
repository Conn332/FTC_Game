local game = {}

function game:new()
	local o = {
		["battery"] = 5,
		["batteryMax"] = 5,
		["gameover"] = false,
		["fading"] = 5,
		["fadingMax"] = 5
	}

	setmetatable(o,self)
	self.__index = self

	return o
end

function game:update(dt)
	if self.gameover then
		self.fading = self.fading-dt
		if self.fading < 0 then
			self.fading = 0
		end
	else
		self.battery = self.battery-dt
		if self.battery < 0 then 
			self.battery=0 
			self.gameover = true
		end
	end
end

function game:draw()
	love.graphics.setColor(255-((self.battery/self.batteryMax-.5)/.5)*255,(((self.battery+.5)/(self.batteryMax+.5)-.25)/.25)*255,0)
	love.graphics.rectangle("fill",10,70,40,-60*self.battery/self.batteryMax)

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line",10,10,40,60)

	if self.gameover then
		love.graphics.setColor(0,0,0,255*(1-self.fading/self.fadingMax))
		local w, h = love.graphics.getDimensions()
		love.graphics.rectangle("fill",0,0,w,h)
	end
end

return game