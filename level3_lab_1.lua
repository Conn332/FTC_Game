local level = {}
e = require "enemy"
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
		["type"] = "level"
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 430
	self.player.y = 1785
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