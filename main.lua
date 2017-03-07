local player

function love.load()
	OPlayer = require "player"
	OBackground = require "background"
	OGame = require "game"
	OEnemy = require "enemy"
	OFEnemy = require "fastEnemy"
	OTEnemy = require "tankEnemy"
	ORock = require "rock"
	OLevel = require "level"

	player = OPlayer:new()
	background = OBackground:new("Temporary_Background.png",player)
	level = OLevel:new(player,background)
	player:setLevel(level)
	game = OGame:new()
	enemy = OEnemy:new(100,100,player)
end
function love.mousereleased(x,y,b)
	rock = ORock:new(0,0,x,y,player)
end
function love.update(dt)
	if not game.gameover then
		player:update(dt)
	end
	game:update(dt)
	enemy:update(dt)
	if rock then
		rock:update(dt)
	end
end
function love.draw()
	level:draw()
	if rock then
		rock:draw()
	end
	player:draw()
	game:draw()
end