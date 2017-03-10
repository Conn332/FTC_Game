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
			{515,1065,1140,1370},
			{-285,1065,515,1210},
			{-285,430,20,1065},
			{-285,430,515,570},
			{515,270,1300,735},
			{1000,430,1140,575}
		},
		["done"] = false,
		["type"] = "level"
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 990
	self.player.y = 1220
	self.enemies = {
		e:new(-225,1000,self.player,self),
		he:new(-110,1135,self.player,self),
		he:new(505,505,self.player,self),
		fe:new(-50,620,self.player,self)
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
	for _,v in ipairs(self.enemies) do
		v:draw()
	end
end

return level