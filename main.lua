local player
function love.load()
	OPlayer = require "player"
	OBackground = require "background"
	OGame = require "game"


	player = OPlayer:new()
	background = OBackground:new("background.png",player)
	game = OGame:new()
end
function love.update(dt)
	if not game.gameover then
		player:update(dt)
	end
	game:update(dt)
end
function love.draw()
	background:draw()
	player:draw()
	game:draw()
end