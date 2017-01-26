local player = {}

function player:new()
	local o = {
		["x"] = 200,
		["y"] = 200,
		["acc"] = 1000,
		["hp"] = 100,
		["friction"] = .2,
		["vel"] = {["hor"] = 0, ["ver"] = 0},
		["battery"] = 60,
		["batteryMax"] = 60
	}

	setmetatable(o,self)
	self.__index = self

	return o
end
function player:update(dt)
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

	self.x = self.x + self.vel.hor*dt
	self.y = self.y + self.vel.ver*dt

	self.vel.hor = self.vel.hor*(1-self.friction*60*dt)
	self.vel.ver = self.vel.ver*(1-self.friction*60*dt)

	self.battery = self.battery-dt
	if self.battery < 0 then self.battery=0 end

end
function player:draw()
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill",self.x,self.y,10,10)
	
	love.graphics.setColor(255-((self.battery/self.batteryMax-.5)/.5)*255,(((self.battery+.5)/(self.batteryMax+.5)-.25)/.25)*255,0)
	love.graphics.rectangle("fill",10,70,40,-60*self.battery/self.batteryMax)

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line",10,10,40,60)

end

return player