local level = {}
e = require "enemy"
b = require "background"

function level:new(player,background)
	local o = {
		["player"] = player,
		["background"] = b:new(background,player),
		["walls"] = { 
			{355,1625,1635,1785},
			{1315,1305,1635,1785},
			{1315,1305,3235,1465},
			{2915,825,3235,1465},
			{1315,825,3235,985},
			{1315,35,1635,985},
			{675,345,1635,505},
			{675,215,995,345}
		},
		["done"] = false,
		["type"] = "level",
		["text"] = {
			{"Press 'U' or 'I' to Attack", 1200, 1810}
		}
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 500
	self.player.y = 1700
	self["enemies"] = {
		e:new(1748,1388,self.player,self)
	}
end
function level:update(dt)
	for i,v in ipairs(self.enemies) do
		v:update(dt)
	end

	v = self.walls[8]

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

	love.graphics.setColor(255,255,255)
	for _,v in ipairs(self.text) do
		love.graphics.print(v[1],v[2]-self.player.x,v[3]-self.player.y)
	end

	for _,v in ipairs(self.enemies) do
		v:draw()
	end
end

return level