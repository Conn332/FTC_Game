local cutscene = {}

function cutscene:new()
	local o = {
		["images"] = {
			love.graphics.newImage("ending_animation/ending_base.png"),
			love.graphics.newImage("ending_animation/ending_frame_1.png"),
			love.graphics.newImage("ending_animation/ending_frame_2.png"),
			love.graphics.newImage("ending_animation/ending_frame_3.png"),
			love.graphics.newImage("ending_animation/ending_frame_4.png"),
			love.graphics.newImage("ending_animation/ending_frame_5.png"),
			love.graphics.newImage("ending_animation/ending_frame_6.png")
		},
		["type"] = "cutscene",
		["done"] = false,
		["i"] = 1,
		["timer"] = 0
	}

	setmetatable(o,self)
	self.__index = self

	return o
end
function cutscene:complete()
	return self.done
end
function cutscene:update(dt) 
	self.timer = self.timer + dt
	if self.timer > .2 then
		self.timer = self.timer -.2
		self.i = self.i + 1
		if self.i > #self.images then
			self.i = #self.images
			self.done = true
		end
	end
end
function cutscene:draw()
	love.graphics.draw(self.images[self.i],0,0)
end


return cutscene