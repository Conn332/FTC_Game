local level = {}
e = require "enemy"
he = require "heavyEnemy"
fe = require "fastEnemy"
b = require "background"

function level:new(player,background)
	local o = {
		["enemies"] = {},
		["player"] = player,
		["background"] = b:new(background,player),
		["walls"] = { 
			{-260,945,685,1890},
			{-260,540,45,945},
			{-260,540,525,690},
			{220,375,525,690},
			{220,375,525,480}
		},
		["done"] = false,
		["type"] = "level",
		["text"] = {
			{"Captain: Robot! Wherever you went we finally have reception to communicate!",380,1505,45},
			{"Captain: It looks like you are in a research facility. Maybe there is evidence as to why humans left Earth?",-225,1505,60},
			{"Captain: Report back if you find anything",55,550,30}
		}
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 430
	self.player.y = 1785
	self.enemies = {
		e:new(-200,1125,self.player,self),
		e:new(-175,575,self.player,self),
		he:new(-45,1185,self.player,self),
		fe:new(75,655,self.player,self)
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
		love.graphics.rectangle("fill",v[2]-self.player.x+w/2,v[3]-self.player.y+h/2,200,v[4])
		love.graphics.setColor(255,255,255)
		love.graphics.printf(v[1],v[2]-self.player.x+w/2,v[3]-self.player.y+h/2,200)
	end

	for _,v in ipairs(self.enemies) do
		v:draw()
	end
end

return level