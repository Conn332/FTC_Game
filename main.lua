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

	bgs = love.filesystem.getDirectoryItems("backgrounds")

	player = OPlayer:new()
	levels = {}
	for _,v in ipairs(bgs) do
		table.insert(levels,OLevel:new(player,OBackground:new("backgrounds/"..v,player)))
	end

	level = 1

	player:setLevel(level)
	game = OGame:new()
	enemy = OEnemy:new(100,100,player)
end
function love.mousereleased(x,y,b)
	rock = ORock:new(0,0,x,y,player)
end
function love.keyreleased(key)
	if key == "[" then
		level = level-1
		if level == 0 then level = #levels end
	elseif key == "]" then
		level = level+1
		if level > #levels then level = 1 end
	end
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
	levels[level]:draw()
	if rock then
		rock:draw()
	end
	player:draw()
	game:draw()
	love.graphics.print(tostring(player.x),0,100)
	love.graphics.print(tostring(player.y),0,110)
end