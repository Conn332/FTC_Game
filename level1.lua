local level = {}
e = require "enemy"
b = require "background"

function level:new(player,background)
	local o = {
		["enemies"] = {},
		["player"] = player,
		["background"] = b:new(background,player),
		["walls"] = { 
			{1425,318,1675,630},
			{1490,-52,1615,320},
			{1235,-122,1555,60},
			{1050,-88,1487,-20},
			{980,-30,1175,295},
			{980,280,1105,420},
			{795,350,1105,420},
			{800,-120,960,420},
			{355,-25,850,65},
			{290,10,355,161},
			{105,100,310,345}
		},
		["done"] = false,
		["type"] = "level",
		["text"] = {
			{"Hello recuit! Welcome to Earth! WASD to move.",1595,380,30},
			{"For longer than we can remember, the human race has been on a spaceship orbiting Earth",1190,-115,60},
			{"We've been up here so long that we have forgotten why we left in the first place", 850, 390,45},
			{"Your mission is to follow these pre-recorded messages and determine if it is safe for the human race to return to Earth", 555, -50,75}
		},
		["nature"] = love.audio.newSource("sound/Nature.mp3","static")
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 1550
	self.player.y = 475
	self.nature:setLooping(true)
	self.nature:play()
end
function level:update(dt)
	for i,v in ipairs(self.enemies) do
		v:update(dt)
	end
	v = self.walls[11]
	if self.player.x > v[1] and self.player.y > v[2] and self.player.x < v[3] and self.player.y < v[4] then
		self.nature:stop()
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