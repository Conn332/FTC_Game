local cutscene = {}

function cutscene:new(background)
	local o = {
		["background"] = love.graphics.newImage(background),
		["type"] = "cutscene",
		["done"] = false
	}

	setmetatable(o,self)
	self.__index = self

	return o
end
function cutscene:complete()
	return self.done
end
function cutscene:mousereleased(x,y,b)
	if x > 70 and x < 470 and y > 270 and y < 400 then
		self.done = true
	end
end
function cutscene:update(dt) end
function cutscene:draw()
	love.graphics.draw(self.background,0,0)
end


return cutscene