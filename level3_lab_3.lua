local level = {}
e = require "enemy"
b = require "background"

function level:new(player,background)
	local o = {
		["enemies"] = {},
		["player"] = player,
		["background"] = b:new(background,player),
		["walls"] = { 
			{-130,985,490,1690},
			{20,1690,330,1850},
			{100,1140,260,1240}
		},
		["done"] = false,
		["type"] = "level",
		["note"] = love.graphics.newImage("final_sprites/note.png"),
		["text"] = {
			{"Those look like lab notes up ahead! Go get them so we can examine them while you continue exploring.",30,1465,60}
		}
	}

	setmetatable(o, self)
	self.__index = self

	return o
end
function level:start()
	self.player.x = 185
	self.player.y = 1775
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

	local w,h = love.graphics.getDimensions()

	love.graphics.draw(self.note,100-self.player.x+w/2,1140-self.player.y+h/2)
end

return level