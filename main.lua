collision = require("collision")
require("modes")
require("objects")
require("functions")
require("values")

function love.load()
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})

	modes = {mode1 = mode_see, mode2 = mode_move, mode3 = mode_attack}
	mode = "mode"..key_see

	state = "start" -- or "game_running" or "take_name" or "dead"

	music_bergakung:play()
	music_bergakung:setLooping(true)
end

function love.keypressed(key)
	if state == "game_running" then
		if key == "escape" then
			state = "start"
			reset_state_values()
			mode = "mode"..key_see
			music_penta:stop()
			music_western:stop()
			music_bergakung:play()
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
			music_bergakung:stop()
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
		if key == "backspace" and #hs_holder > 0 then
				hs_holder = hs_holder:sub(1,#hs_holder - 1)
		end
		if string.find(alphabet, key) then
			if #hs_holder < 20 then
				hs_holder = hs_holder..key
			end
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
		game_time = game_time + dt
		if game_time > 6 and not game_music_started then
			game_music_started = true
 			music_penta:play()
 			music_penta:setLooping(true)
 		end

		modes[mode].func_update(dt)

		-- check if an enemy has hit the player
		for i, enemy in pairs(enemies) do
			if collision.collisionTest(player.shape, enemy.shape) then
				sound_player_hit:play()
				curr_damage = curr_damage + 1
				table.remove(enemies, i)
			end
		end

		-- check if any shot has hit an enemy
		for i, shot in pairs(shots) do
			for j, enemy in pairs(enemies) do
				if collision.collisionTest(shot.shape, enemy.shape) then
					sound_enemy_hit:play()
					table.remove(shots, i)
					table.remove(enemies, j)
				end
			end
		end

		if curr_damage > max_damage then
			lose_game()
		end
	end

end

function love.draw()
	if state == "game_running" then
		modes[mode].func_draw()
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
	game_time = 0

	music_western:play()
end

function lose_game()
	mode = "mode"..key_see
	music_penta:stop()
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
		write_centered(hs_holder, medium_font, 2.5*win_h / 4, win_w)
	elseif state == "death" then
		write_centered("You died...", big_font, 0.7*win_h / 4, win_w) 
		write_centered("Press <space> to go to the main menu.",
						medium_font, 2*win_h / 4, win_w)
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
	write_centered("Current highscore is "..highscore.." seconds, held by "..hs_holder, 
					medium_font, y + 2*h, win_w)
	write_centered("Press <space> to start game!", medium_font, 3.2*win_h / 4, win_w)
	
	love.graphics.rectangle("line", x - dist, y, w, h, w/2, h/2) 
	love.graphics.rectangle("line", x, y, w, h, 0) 
	love.graphics.polygon("line", {x + dist, y, 
									x + dist, y + h, 
									x + w + dist, y + h/2}) 
end
