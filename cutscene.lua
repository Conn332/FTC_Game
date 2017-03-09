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
function cutscene:update(dt) end
function cutscene:draw()
	love.graphics.draw(self.background,0,0)
end


return cutscene