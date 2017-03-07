local level = {}
e = require "enemy"

function level:new(player,background)
	local o = {
		["enemies"] = {},
		["player"] = player,
		["background"] = background,
		["walls"] = { 
			{0,0,200,100}
		}
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:update(dt)
	for _,v in ipairs(self.enemies) do
		v:update(dt)
	end
end
function level:addEnemy(type,x,y)
	table.insert(self.enemies,e:new(x,y,self.player))
end
function level:complete()

end
function level:checkCollision()
	for _,v in iparis(self.walls) do
		if self.player.x > v[1] and self.player.y > v[2] and self.player.x < v[3] and self.player.y < v[4] then
			return true
		else
			return false
		end
	end
end
function level:checkAttack(x1,y1,x2,y2)

	for _,v in ipairs(self.enemies) do
		local x = v.pos.x
		if x >= x1 and x <= x2 and y >= y1 and y <= y2 then
			return true
		else
			return false
		end
	end
end
function level:draw()
	self.background:draw()
	for _,v in ipairs(self.enemies) do
		v:draw()
	end
end

return level