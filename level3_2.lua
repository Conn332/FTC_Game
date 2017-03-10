local level = {}
e = require "enemy"
fe = require "fastEnemy"
he = require "heavyEnemy"
b = require "background"

function level:new(player,background)
	local o = {
		["enemies"] = {},
		["player"] = player,
		["background"] = b:new(background,player),
		["walls"] = { 
			{1680,760,1840,1320},
			{1680,760,2640,840},
			{2480,440,2640,840},
			{2480,440,2960,520},
			{2800,180,2960,520},
			{2800,180,2960,200}
		},
		["done"] = false,
		["type"] = "level",
		["text"] = {
			{"RUN!!",1550,940,15}
		}
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 1760
	self.player.y = 1035
	self.enemies = {
		fe:new(1765,1270,self.player,self),
		fe:new(1700,1215,self.player,self),
		fe:new(1700,1255,self.player,self),
		fe:new(1725,1300,self.player,self),
		fe:new(1795,1300,self.player,self),
		fe:new(1805,1240,self.player,self),
		fe:new(1800,1195,self.player,self),
		fe:new(1815,1140,self.player,self)
	}
end
function level:update(dt)
	for i,v in ipairs(self.enemies) do
		v:update(dt)
	end

	v = self.walls[#self.walls]
	if self.player.x > v[1] and self.player.y > v[2] and self.player.x < v[3] and self.player.y < v[4] then
		self.done = true
	end	
end
function level:newEnemy(type,x,y)
	table.insert(self.enemies,e:new(x,y,self.player))
end
function level:complete()
	return self.done
end
function level:checkCollision()
	for _,v in ipairs(self.walls) do
		if self.player.x > v[1] and self.player.y > v[2] and self.player.x < v[3] and self.player.y < v[4] then
			return false
		end
	end
	return true
end
function level:checkEnemyCollision(e)
	for _,v in ipairs(self.walls) do
		if e.pos.x > v[1] and e.pos.y > v[2] and e.pos.x < v[3] and e.pos.y < v[4] then
			return false
		end
	end
	return true
end
function level:checkAttack(x1,y1,x2,y2,ranged)

	for i,v in ipairs(self.enemies) do
		local x = v.pos.x
		local y = v.pos.y
		if x >= x1 and x <= x2 and y >= y1 and y <= y2 and v.hp > 0 then
			if ranged then
				v.ouch = 1
			else
				v.hp = v.hp-1
				v.ouch = .5
			end
			return true
		end
	end

	return false
end
function level:draw()
	self.background:draw()
	local w,h = love.graphics.getDimensions()

	for _,v in ipairs(self.text) do
		love.graphics.setColor(100,100,255)
		love.graphics.rectangle("fill",v[2]-self.player.x+w/2,v[3]-self.player.y+h/2,50,v[4])
		love.graphics.setColor(255,255,255)
		love.graphics.printf(v[1],v[2]-self.player.x+w/2,v[3]-self.player.y+h/2,50)
	end
	for _,v in ipairs(self.enemies) do
		v:draw()
	end
end

return level