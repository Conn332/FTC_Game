local player
function love.load()
	OPlayer = require "player"
	player = OPlayer:new()
end
function love.update(dt)
	player:update(dt)
end
function love.draw()
	player:draw()
end