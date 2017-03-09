local player = {}

function player:new()
	local o = {
		["x"] = 0,
		["y"] = 0,
		["acc"] = 1000,
		["hp"] = 4,
		["friction"] = .2,
		["vel"] = {["hor"] = 0, ["ver"] = 0},
		["images"] = {
				{love.graphics.newImage("final_sprites/robot_sprites/robot_1_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_1_moving.png")}, --left
				{love.graphics.newImage("final_sprites/robot_sprites/robot_2_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_2_moving.png")}, --down
				{love.graphics.newImage("final_sprites/robot_sprites/robot_3_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_3_moving.png")}, --right
				{love.graphics.newImage("final_sprites/robot_sprites/robot_4_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_4_moving.png")}, --up
				{love.graphics.newImage("final_sprites/robot_sprites/robot_5_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_5_moving.png")}, --down left
				{love.graphics.newImage("final_sprites/robot_sprites/robot_6_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_6_moving.png")}, --down right
				{love.graphics.newImage("final_sprites/robot_sprites/robot_7_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_7_moving.png")}, --up left
				{love.graphics.newImage("final_sprites/robot_sprites/robot_8_standing.png"), love.graphics.newImage("final_sprites/robot_sprites/robot_8_moving.png")}, --up right
				{love.graphics.newImage("final_sprites/robot_sprites/robot_1_hitting.png")}, --left 9
				{love.graphics.newImage("final_sprites/robot_sprites/robot_2_hitting.png")}, --down 10
				{love.graphics.newImage("final_sprites/robot_sprites/robot_3_hitting.png")}, --right 11
				{love.graphics.newImage("final_sprites/robot_sprites/robot_4_hitting.png")}, --up 12
				{love.graphics.newImage("final_sprites/robot_sprites/robot_5_hitting.png")}, --down left 13
				{love.graphics.newImage("final_sprites/robot_sprites/robot_6_hitting.png")}, --down right 14
				{love.graphics.newImage("final_sprites/robot_sprites/robot_7_hitting.png")}, --up left 15
				{love.graphics.newImage("final_sprites/robot_sprites/robot_8_hitting.png")}, --up right 16
				{love.graphics.newImage("final_sprites/robot_sprites/robot_ouch.png")} --17
			},
		["i"] = 1,
		["frame"] = 1,
		["fTimer"] = .1,
		["aTimer"] = 0,
		["rTimer"] = 0,
		["ORock"] = require "rock",
		["rocks"] = {},
		["mRange"] = 75,
		["xmod"] = -1,
		["ymod"] = 0,
		["ouch"] = 0
		
	}

	setmetatable(o,self)
	self.__index = self

	return o
end
function player:setLevel(level)
	self.level = level
end
function player:update(dt)

	if self.aTimer <= 0 then
		if self.i > 8 and self.i < 17 then
			self.i = self.i-8
		end
		if love.keyboard.isDown("a") then
			self.vel.hor = self.vel.hor-self.acc*dt
		end
		if love.keyboard.isDown("s") then
			self.vel.ver = self.vel.ver+self.acc*dt
		end
		if love.keyboard.isDown("d") then
			self.vel.hor = self.vel.hor+self.acc*dt
		end
		if love.keyboard.isDown("w") then
			self.vel.ver = self.vel.ver-self.acc*dt
		end

		if love.keyboard.isDown("u") then
			self.aTimer = .5
			self.vel.ver = 0
			self.vel.hor = 0
			
			if self.xmod == 1 then
				if self.ymod == 1 then --down right
					self.level:checkAttack(self.x,self.y,self.x+self.mRange,self.y+self.mRange)
					self.frame = 1
					self.i = 14
				elseif self.ymod == 0 then -- right
					self.level:checkAttack(self.x,self.y-self.mRange/2,self.x+self.mRange,self.y+self.mRange/2)
					self.frame = 1
					self.i = 11
				else -- up right
					self.level:checkAttack(self.x,self.y,self.x+self.mRange,self.y-self.mRange)
					self.frame = 1
					self.i = 16
				end
			elseif self.xmod == 0 then
				if self.ymod == 1 then --up
					self.level:checkAttack(self.x-self.mRange/2,self.y,self.x+self.mRange/2,self.y+self.mRange)
					self.frame = 1
					self.i = 10
				elseif self.ymod == 0 then
					print("wat")
				else --down
					self.level:checkAttack(self.x-self.mRange/2,self.y,self.x+self.mRange/2,self.y-self.mRange)
					self.frame = 1
					self.i = 12
				end
			else
				if self.ymod == 1 then --down left
					self.level:checkAttack(self.x-self.mRange,self.y,self.x,self.y+self.mRange)
					self.frame = 1
					self.i = 13
				elseif self.ymod == 0 then --left
					self.level:checkAttack(self.x-self.mRange,self.y-self.mRange/2,self.x,self.y+self.mRange/2)
					self.frame = 1
					self.i = 9
				else --up left
					self.level:checkAttack(self.x-self.mRange,self.y-self.mRange,self.x,self.y)
					self.frame = 1
					self.i = 15
				end
			end
		end
	elseif self.aTimer > 0 then
		self.aTimer = self.aTimer-dt
	end
	if self.rTimer > 0 then
		self.rTimer = self.rTimer-dt
	else
		if love.keyboard.isDown("i") then
			self.rTimer = 1
			table.insert(self.rocks,self.ORock:new(300*self.xmod,300*self.ymod,self.x,self.y,self))
		end
	end
	if #self.rocks > 0 then
		for i,v in ipairs(self.rocks) do
			if v.dead and v.timer <= 0 then
				table.remove(self.rocks, i)
				print("removed: "..i)
			else
				v:update(dt)
			end
		end
	end

	local lx = self.x
	local ly = self.y

	self.x = self.x + self.vel.hor*dt

	if self.level:checkCollision() then
		self.x = lx
	end

	self.y = self.y + self.vel.ver*dt

	if self.level:checkCollision() then
		self.y = ly
	end

	if math.abs(self.vel.ver) == 0 then
		if self.vel.hor > 5 then --right
			self.i = 3
			self.xmod = 1
			self.ymod = 0
		elseif self.vel.hor < -5 then --left
			self.i = 1
			self.xmod = -1
			self.ymod = 0
		end
	else --add images here
		if self.vel.hor == 0 then
			if self.vel.ver > 5 then --down
				self.i = 2
				self.xmod = 0
				self.ymod = 1
			elseif self.vel.ver < -5 then --up
				self.i = 4
				self.xmod = 0
				self.ymod = -1
			end
		elseif self.vel.hor > 5 then
			if self.vel.ver > 5 then --down right
				self.i = 6
				self.xmod = 1
				self.ymod = 1
			elseif self.vel.ver < -5 then --down left
				self.i = 8
				self.xmod = 1
				self.ymod = -1
			end
		elseif self.vel.hor < -5 then
			if self.vel.ver > 5 then --up right
				self.i = 5
				self.xmod = -1
				self.ymod = 1
			elseif self.vel.ver < -5 then --up left
				self.i = 7
				self.xmod = -1
				self.ymod = -1
			end
		end
	end

	if (math.abs(self.vel.hor) > 5 or math.abs(self.vel.ver) > 5) or self.frame > 1 then
		self.fTimer = self.fTimer - dt
	else
		self.fTimer = .1
	end

	if self.aTimer > 0 then
		if self.i == 1 then
			self.i = 3
			self.frame = 1
		elseif self.i == 2 then
			self.i = 4
			self.frame = 1
		end
	end

	if self.ouch > 0 then
		self.i = 17
		self.frame = 1
	end

	if self.fTimer <= 0 then
		self.frame = self.frame+1
		if self.frame > 2 then self.frame = 1 end
		self.fTimer = self.fTimer + .1 
	end
	if self.ouch > 0 then
		self.ouch = self.ouch-dt
	end

	self.vel.hor = self.vel.hor*(1-self.friction*60*dt)
	self.vel.ver = self.vel.ver*(1-self.friction*60*dt)

	if math.abs(self.vel.hor) < 5 then
		self.vel.hor = 0
	end
	if math.abs(self.vel.ver) < 5 then
		self.vel.ver = 0
	end

	if self.frame > #self.images[self.i] then
		self.frame = #self.images[self.i]
	end


end
function player:draw()
	love.graphics.setColor(255,255,255)
	local w, h = love.graphics.getDimensions()
	love.graphics.draw(self.images[self.i][self.frame],w/2-self.images[self.i][self.frame]:getWidth()/(2*4),h/2-self.images[self.i][self.frame]:getHeight()/(2*4),0,.25,.25)
	for i,v in ipairs(self.rocks) do
		v:draw()
	end
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill",200,10,400,30)
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill",200,10,400*self.hp/4,30)
end

return player