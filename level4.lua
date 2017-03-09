local level = {}
e = require "enemy"
b = require "background"

function level:new(player,background)
	local o = {
		["enemies"] = {},
		["player"] = player,
		["background"] = b:new(background,player),
		["walls"] = { 
			{3290,900,4085,1220},
			{3290,900,3600,1855},
			{3125,1460,3600,1855},
			{2485,1220,3126,1860},
			{1685,1060,2485,1539},
			{1685,980,2165,1060},
			{1200,415,2325,980},
			{1685,262,2325,420}
		},
		["done"] = false,
		["type"] = "level"
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 3925
	self.player.y = 1060
end
function level:update(dt)
	for i,v in ipairs(self.enemies) do
		v:update(dt)
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
function level:checkAttack(x1,y1,x2,y2)

	for i,v in ipairs(self.enemies) do
		local x = v.pos.x
		local y = v.pos.y
		if x >= x1 and x <= x2 and y >= y1 and y <= y2 and v.hp > 0 then
			v.hp = v.hp-1
			v.ouch = .5
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