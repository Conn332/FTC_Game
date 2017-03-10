local rock = {}

function rock:new(hvel,vvel,x,y,player)
	local o = {
		["x"] = x,
		["y"] = y,
		["hvel"] = hvel,
		["vvel"] = vvel,
		["timer"] = 1,
		["images"] = {
			{love.graphics.newImage("FLYING_ROCKS_.png")},
			{love.graphics.newImage("Melee_Hit.png")}
		},
		["i"] = 1,
		["frame"] = 1,
		["dead"] = false,
		["player"] = player
	}

	setmetatable(o,self)
	self.__index = self

	return o
end
function rock:update(dt)
	self.timer = self.timer-dt

	if not self.dead then
		self.x = self.x+self.hvel*dt
		self.y = self.y+self.vvel*dt

		if self.player.level:checkAttack(self.x-10,self.y-10,self.x+10,self.y+10,true) then self.timer = 0 end

		if self.timer <= 0 then
			self.i = 2
			self.dead = true
			self.timer = 1
			self.hvel = 0
			self.vvel = 0
		end
	else
		self = nil
	end

end
function rock:draw()
	local w,h = love.graphics.getDimensions()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.images[self.i][self.frame],self.x-self.player.x+w/2-self.images[self.i][self.frame]:getWidth()/4,self.y-self.player.y+h/2-self.images[self.i][self.frame]:getHeight()/4,0,.5,.5)
end

return rock