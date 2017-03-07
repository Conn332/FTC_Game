local enemy = {}

function enemy:new(x,y,player)

	local behavior = 1--math.random(2)--1 = aggressive, 2 = defensive

	local o = {
		["hp"] = 50,
		["pos"] = {["x"] = x,["y"] = y},
		["acc"] = 1100,
		["vel"] = {["hor"] = 0,["ver"] = 0},
		["target"] = {["x"] = 0,["y"] = 0},
		["behavior"] = behavior,
		["friction"] = .2,
		["w"] = 10,
		["h"] = 10,
		["reaction"] = .5,
		["rTimer"] = 0,
		["player"] = player
	}

	setmetatable(o,self)
	self.__index = self

	return o
end

function enemy:getDistance()
	return math.sqrt((self.pos.x-self.target.x)^2+(self.pos.y-self.target.y)^2)
end
function enemy:getXDistance()
	return math.abs(self.pos.x-self.target.x)
end
function enemy:getYDistance()
	return math.abs(self.pos.y-self.target.y)
end

function enemy:getYMult()
	if self.target.y > self.pos.y then
		return 1
	else
		return -1
	end
end
function enemy:getXMult()
	if self.target.x > self.pos.x then
		return 1
	else
		return -1
	end
end

function enemy:update(dt)
	self.rTimer = self.rTimer-dt
	if self.rTimer <= 0 then
		self.rTimer = self.reaction
		self.target.x = self.player.x
		self.target.y = self.player.y
	end
	if self.behavior == 1 then
		if self:getDistance() > self.behavior*20 then
			if self:getYDistance() > 5 then
				self.vel.ver = self.vel.ver + self.acc*dt*self:getYMult()
			else
				self.vel.ver = self.vel.ver + self.acc*dt*self:getYMult()*(self:getYDistance()/5)
			end
			if self:getXDistance() > 5 then
				self.vel.hor = self.vel.hor + self.acc*dt*self:getXMult()
			else
				self.vel.hor = self.vel.hor + self.acc*dt*self:getXMult()*(self:getXDistance()/5)
			end
		end
	end


	self.pos.x = self.pos.x + self.vel.hor*dt
	self.pos.y = self.pos.y + self.vel.ver*dt

	self.vel.hor = self.vel.hor*(1-self.friction*60*dt)
	self.vel.ver = self.vel.ver*(1-self.friction*60*dt)
end
function enemy:draw()
	love.graphics.setColor(0,255,0)
	local w,h = love.graphics.getDimensions()
	love.graphics.rectangle("fill",self.pos.x-self.player.x+w/2-self.w/2,self.pos.y-self.player.y+h/2-self.h/2,10,10)
end

return enemy