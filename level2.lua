local level = {}
e = require "enemy"
ef = require "fastEnemy"
b = require "background"

function level:new(player,background)
	local o = {
		["player"] = player,
		["enemies"] = {},
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
			{"After exploring for a while, you stumble across an abandoned city",360,1800,45},
			{"Captain: we're detecting some kind of life ahead, if it turns aggressive you have permission to use lethal force with your drill, using the 'U' key. You can also stun enemies at a range by pressing I",1170,1640,100},
			{"Captain: Nice work! (we hope). We're getting more life signs ahead, so be careful",2160,1320,45},
			{"Captain: You're not invincible and if whatever thos things are damage you too badly, you'll enter into a repair state which quickly repairs you and prevents damage for a short time, but drains battery",2380,1425,100},
			{"Captain: Unfortunately for us, there is an ion storm around Earth. It will disrupt communication and leave you with a shortened battery life.", 2825,1310,70}
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
		e:new(1748,1388,self.player,self), --normal
		e:new(2990,960,self.player,self),
		e:new(3125,930,self.player,self),
		e:new(2535,860,self.player,self),
		e:new(2140,855,self.player,self),
		he:new(2050,950,self.player,self),
		he:new(1385,755,self.player,self),
		he:new(1565,700,self.player,self),
		fe:new(1585,855,self.player,self)
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