local player
function love.load()
	OPlayer = require "player"
	OBackground = require "background"
	OGame = require "game"
	OEnemy = require "enemy"


	player = OPlayer:new()
	background = OBackground:new("background.png",player)
	game = OGame:new()
	enemy = OEnemy:new(500,500,player)
end
function love.update(dt)
	if not game.gameover then
		player:update(dt)
	end
	game:update(dt)
	enemy:update(dt)
end
function love.draw()
	background:draw()
	enemy:draw()
	player:draw()
	game:draw()
end