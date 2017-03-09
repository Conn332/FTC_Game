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

	title = require "title"

	level1 = require "level1"
	level2 = require "level2"
	level3_1 = require "level3_1"
	level3_2 = require "level3_2"
	level3_lab_1 = require "level3_lab_1"
	level3_lab_2 = require "level3_lab_2"
	level3_lab_3 = require "level3_lab_3"
	level4 = require "level4"

	finalCut = require "finalCut"


	bgs = love.filesystem.getDirectoryItems("backgrounds")

	player = OPlayer:new()
	levels = {
		title:new("cutscenes/title_screen.png"),
		level1:new(player, "final_sprites/levels/level_1.png"),
		level2:new(player, "final_sprites/levels/level_2.png"),
		level3_1:new(player, "final_sprites/levels/level_3_1.png"),
		level3_2:new(player,"final_sprites/levels/level_3_2.png"),
		level3_lab_1:new(player, "final_sprites/levels/level_3_lab_1.png"),
		level3_lab_2:new(player, "final_sprites/levels/level_3_lab_2.png"),
		level3_lab_3:new(player, "final_sprites/levels/level_3_lab_3.png"),
		level4:new(player, "final_sprites/levels/level_4.png"),
		finalCut:new()
	}

	level = 1

	player:setLevel(levels[1])
	game = OGame:new()
end
function love.mousereleased(x,y,b)
	if levels[level].mousereleased then
		levels[level]:mousereleased(x,y,b)
	end

end
function love.keyreleased(key)
	if key == "[" then
		level = level-1
		if level == 0 then level = #levels end
		player:setLevel(levels[level])
	elseif key == "]" then
		level = level+1
		if level > #levels then level = 1 end
		player:setLevel(levels[level])
	end
end
function love.update(dt)
	if not game.gameover and levels[level].type == "level" then
		player:update(dt)
	end
	--game:update(dt)
	levels[level]:update(dt)

	local complete, n = levels[level]:complete()
	if complete then
		n = n or level+1
		level = n
		if level > #levels then
			level = 1
		end
		player:setLevel(levels[level])
		if levels[level].start then 
			levels[level]:start() 
		end
	end
	if player.hp == 0 then 
		player.hp = 4
		player.ouch = 2
		game.battery = game.batter-15
	end
end
function love.draw()
	levels[level]:draw()
	if rock then
		rock:draw()
	end
	if levels[level].type == "level" then
		player:draw()
		game:draw()
		local w,h = love.graphics.getDimensions()
		love.graphics.print(tostring(player.x+love.mouse.getX()-w/2),0,100)
		love.graphics.print(tostring(player.y+love.mouse.getY()-h/2),0,110)
	end
end