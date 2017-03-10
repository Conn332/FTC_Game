local enemy = {}

function enemy:new(x,y,player,level)

	local behavior = 1--math.random(2)--1 = aggressive, 2 = defensive

	local o = {
		["hp"] = 100,
		["pos"] = {["x"] = x,["y"] = y},
		["acc"] = 500,
		["vel"] = {["hor"] = 0,["ver"] = 0},
		["target"] = {["x"] = 0,["y"] = 0},
		["behavior"] = behavior,
		["friction"] = .2,
		["reaction"] = .5,
		["rTimer"] = 0,
		["player"] = player,
		["images"] = {
			{love.graphics.newImage("final_sprites/enemies/slime_2_1.png"),love.graphics.newImage("final_sprites/enemies/slime_2_1_flipped.png")},
			{love.graphics.newImage("final_sprites/enemies/slime_2_2.png")},
			{love.graphics.newImage("final_sprites/enemies/slime_dead.png")}
		},
		["i"] = 1,
		["frame"] = 1,
		["fTimer"] = .2,
		["hp"] = 5,
		["ouch"] = 0,
		["windup"] = 0,
		["aTimer"] = 0,
		["damage"] = false,
		["level"] = level
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
	self.damage = false
	self.rTimer = self.rTimer-dt
	if self.rTimer <= 0 then
		self.rTimer = self.reaction
		self.target.x = self.player.x
		self.target.y = self.player.y
	end
	if self.hp > 0 then
		if self.windup > 0 then
			self.windup = self.windup-dt
			if self.windup <=0 and self.ouch <= 0 then
				self.aTimer = .5
				if self:getDistance() <= 50 and self.player.ouch <= 0 then
					self.damage = true
					self.player.ouch = .5
					self.player.hp = self.player.hp-1
					self.aTimer = .5
				end
			end
		end
		if self:getDistance() > 50 and self:getDistance() < 250  and self.windup <= 0 and self.aTimer <= 0 and self.ouch <= 0 then
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
		if self:getDistance() <= 50 and self.aTimer <= 0 and self.windup <= 0 then
			self.windup = 1
		end
	else
		self.i = 3
		self.frame = 1
		self.vel.hor = 0
		self.vel.ver = 0
		self.ouch = 0
	end

	if (math.abs(self.vel.hor) > 5 or math.abs(self.vel.ver) > 5) then
		self.fTimer = self.fTimer - dt
	else
		self.fTimer = .2
	end
	if self.fTimer <= 0 then
		self.frame = self.frame+1
		if self.frame > 2 then self.frame = 1 end
		self.fTimer = self.fTimer + .2
	end

	if self.ouch > 0 then
		self.ouch = self.ouch-dt
		self.windup = 0
		self.attack = 0
		if self.ouch < 0 then self.ouch = 0 end
	end
	if self.aTimer > 0 then
		self.aTimer = self.aTimer-dt
		self.i = 2
		self.frame = 1
		if self.aTimer <= 0 then
			self.aTimer = 0
			self.i = 1
		end
	end

	local lx = self.pos.x
	local ly = self.pos.y

	self.pos.x = self.pos.x + self.vel.hor*dt

	if self.level:checkEnemyCollision(self) then
		self.pos.x = lx
	end

	self.pos.y = self.pos.y + self.vel.ver*dt

	if self.level:checkEnemyCollision(self) then
		self.pos.y = ly
	end

	self.vel.hor = self.vel.hor*(1-self.friction*60*dt)
	self.vel.ver = self.vel.ver*(1-self.friction*60*dt)
end
function enemy:draw()
	if self.ouch > 0 then
		love.graphics.setColor(255,255*(1-self.ouch/.5),255*(1-self.ouch/.5))
	elseif self.windup > 0 then
		love.graphics.setColor(255*(self.windup/1),255,255*(self.windup/1))
	else
		love.graphics.setColor(255,255,255)
	end
	local w,h = love.graphics.getDimensions()
	love.graphics.draw(self.images[self.i][self.frame],self.pos.x-self.player.x+w/2-self.images[self.i][self.frame]:getWidth()/8,self.pos.y-self.player.y+h/2-self.images[self.i][self.frame]:getHeight()/8,0,.25,.25)
end

return enemy