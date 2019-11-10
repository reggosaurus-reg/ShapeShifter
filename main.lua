collision = require("collision")
require("modes")
require("objects")
require("functions")

-- KEYMAP
rot_l = "j"
rot_r = "k"
inc_x = "d"
dec_x = "a"
inc_y = "w"
dec_y = "s"
key_see = "1"
key_move = "2"
key_attack = "3"

function love.load()
	win_w = 800	
	win_h = 600
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})

	big_font = love.graphics.newFont("yf16font.ttf", 55)
	medium_font = love.graphics.newFont("yf16font.ttf", 15)
	medium_font:setFilter( "nearest", "nearest" )
	big_font:setFilter( "nearest", "nearest" )

	state = "start" -- or "game_running" or "take_name" or "dead"
	hs_holder = "A. Nonymous"
	highscore = 0
	max_damage = 4
	
	-- Note: mode1 in table is matched with string created in onKeyPressed/initial mode
	modes = {mode1 = mode_see, mode2 = mode_move, mode3 = mode_attack}
	rotation_speed = math.pi * 2  -- half a lap per second

	mode = "mode"..key_see -- initial mode

end

function love.keypressed(key)
	if state == "game_running" then
		if key == "escape" then
			state = "start"
		end
		if key == "9" then
			curr_damage = curr_damage + 1
			if curr_damage > max_damage then
				lose_game()
			end
		end
		-- Modes
		if key == key_see or key == key_move or key == key_attack then
			mode = "mode"..key
		end

		-- Movement
		if key == rot_r then
			player.rotation_dir = player.rotation_dir + 1
		elseif key == rot_l then
			player.rotation_dir = player.rotation_dir - 1
		elseif key == inc_x then
			player.x_dir = player.x_dir + 1
		elseif key == dec_x then
			player.x_dir = player.x_dir - 1
		elseif key == dec_y then
			player.y_dir = player.y_dir + 1
		elseif key == inc_y then
			player.y_dir = player.y_dir - 1
		end

		if key == "space" then
			modes[mode].func_shoot()
		end

	elseif state == "start" then
		if key == "escape" then
			love.event.quit()
		elseif key == "space" or key == "return" then
			start_game()
		end

	elseif state == "death" then
		if key == "space" or key == "return"or key == "escape" then
			state = "start"
		end

	elseif state == "take_name" then
		if key == "return" then
			state = "start"
		end
	
	end
end

function love.keyreleased(key)
	if state == "game_running" then
		if key == rot_r then
			player.rotation_dir = player.rotation_dir - 1
		elseif key == rot_l then
			player.rotation_dir = player.rotation_dir + 1
		elseif key == inc_x then
			player.x_dir = player.x_dir - 1
		elseif key == dec_x then
			player.x_dir = player.x_dir + 1
		elseif key == dec_y then
			player.y_dir = player.y_dir - 1
		elseif key == inc_y then
			player.y_dir = player.y_dir + 1
		end
	end
end

function love.update(dt)
	if state == "game_running" then
		modes[mode].func_update(dt)

		-- check if an enemy has hit the player
		for i, enemy in pairs(enemies) do
			if collision.collisionTest(player.shape, enemy.shape) then
				love.event.quit(1)  -- TODO
			end
		end

		-- check if any shot has hit an enemy
		for i, shot in pairs(shots) do
			for j, enemy in pairs(enemies) do
				if collision.collisionTest(shot.shape, enemy.shape) then
					-- kill enemy
					love.event.quit(2)  -- TODO
				end
			end
		end
	end

end

function love.draw()
	if state == "game_running" then
		modes[mode].func_draw()
		game_time = math.ceil((love.timer.getTime() - game_start_time)*100) / 100
		write_right(time_to_string(game_time), medium_font, win_w, 5)
	elseif state == "start" then
		show_startscreen()
	else
		show_deathscreen()
	end
end

function start_game()
	state = "game_running"
	init_objects()
	game_start_time = love.timer.getTime()
end

function lose_game()
	highscore = math.max(highscore, game_time) 
	if highscore == game_time then
		state = "take_name"
	else
		state = "death"
	end
end

function show_deathscreen()
	if state == "take_name" then
		write_centered("You died...", big_font, 0.7*win_h / 4, win_w) 
		write_centered("... but you beat the highscore! Please enter your name:",
						medium_font, 2*win_h / 4, win_w)
		write_name = true
	elseif state == "death" then
		write_centered("You died...", big_font, 0.7*win_h / 4, win_w) 
		write_centered("Press <space> to go to the main menu.",
						medium_font, 2*win_h / 4, win_w)
		write_name = false
	end
end

function show_startscreen()
	-- Setup
	local w = 60
	local h = 40
	local x = (win_w - w) / 2
	local y = 1.7*win_h / 4
	local dist = 90	

	-- Print 
	write_centered("Shape Shifter", big_font, 0.7*win_h / 4, win_w)
	write_centered("Current highscore is "..highscore.." seconds by "..hs_holder, 
					medium_font, y + 2*h, win_w)
	write_centered("Press <space> to start game!", medium_font, 3.2*win_h / 4, win_w)
	
	love.graphics.rectangle("line", x - dist, y, w, h, w/2, h/2) 
	love.graphics.rectangle("line", x, y, w, h, 0) 
	love.graphics.polygon("line", {x + dist, y, 
									x + dist, y + h, 
									x + w + dist, y + h/2}) 
end
