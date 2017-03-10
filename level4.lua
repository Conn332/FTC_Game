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
		["type"] = "level",
		["text"] = {
			{"Captain: Those lab notes you found were a gold mine! They said that the Earth was becoming too polluted to sustain life, and scientists attempted to create a new organism to consume pollution. However the new organisms mistook humans as pollution and began to attack. The human race was forced to flee Earth.",3445,975,165},
			{"Captain: I believe we can administer a cure to the organisms so they will no longer attack humans, however we will need to drain your battery to do this. Know that your sacrifice will save the human race. Clear the area of any remaining organisms so we can begin.",1850, 1220, 140}
		}
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 3925
	self.player.y = 1060
	self.enemies = {
		e:new(2655,1460,self.player,self),
		e:new(2240,1270,self.player,self),
		e:new(1740,925,self.player,self),
		e:new(1900,935,self.player,self),
		e:new(2090,950,self.player,self),
		e:new(2020,595,self.player,self),
		e:new(2165,480,self.player,self),
		he:new(3190,1495,self.player,self),
		he:new(3195,1620,self.player,self),
		he:new(3180,1720,self.player,self),
		he:new(3225,1825,self.player,self),
		he:new(2690,1560,self.player,self),
		he:new(2800,1475,self.player,self),
		he:new(1845,730,self.player,self),
		he:new(1855,510,self.player,self),
		fe:new(2330,1200,self.player,self),
		fe:new(2260,1395,self.player,self),
		fe:new(2150,730,self.player,self)
	}
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
	for _,v in ipairs(self.enemies) do
		if v.hp > 0 then
			return false
		end
	end
	return true
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