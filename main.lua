collision = require("lib/collision")
require("entities")
require("lib/sound")
require("lib/text")
require("modes")
require("movement")

function love.load()
	win_w = 800	
	win_h = 600

	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})

	hs_holder = "A. Nonymous"
	highscore = 0

	key_right = "right"
	key_left = "left"
	key_up = "up"
	key_down = "down"
	key_see = "1"
	key_move = "2"
	key_attack = "3"

	-- "none", "rot", "move"
	pressed_keys = {left = "none", right = "none", up = "none", down = "none"}

	modes = {mode1 = mode_see, mode2 = mode_move, mode3 = mode_attack}
	mode = "mode"..key_see

	state = "start" -- or "game_running" or "take_name" or "dead" or "info"

	music.bergakung:play()
end

function love.keypressed(key)
	if state == "game_running" then
		if key == "escape" then
			state = "start"
			mode = "mode"..key_see
			music.bergakung:play()
			music.penta:stop()
			music.western:stop()
		end
		-- Modes
		if key == key_see or key == key_move or key == key_attack then
			mode = "mode"..key
		end

		-- Movement
		modes[mode].func_key_pressed(key)

		if key == "space" then
			modes[mode].func_shoot()
		end

	elseif state == "start" then
		if key == "escape" then
			love.event.quit()
		elseif key == "space" or key == "return" then
			state = "info"
		end

	elseif state == "info" then 
		if key == "escape" then
			state = "start"
		elseif key == "space" or key == "return" then
			music.bergakung:stop()
			start_game()
		end


	elseif state == "death" then
		if key == "space" or key == "return" or key == "escape" then
			state = "start"
		end

	elseif state == "take_name" then
		if key == "return" or key == "escape" then
			music.bergakung:play()
			state = "start"
		end
		if key == "backspace" and #hs_holder > 0 then
			if love.keyboard.isDown("lctrl") then hs_holder = "" else
				hs_holder = hs_holder:sub(1, #hs_holder - 1)
			end
		end
		if is_character(key) then
			if #hs_holder < 20 then
				if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
					hs_holder = hs_holder..string.upper(key)
				else
					hs_holder = hs_holder..key
				end
			end
		elseif key == "space" then
			hs_holder = hs_holder.." "
		end
	end
end

function love.keyreleased(key)
	if state == "game_running" then
		modes[mode].func_key_released(key)
	end
end

function love.update(dt)
	if state == "game_running" then
		game_time = game_time + dt
		if game_time > 6 and not music.main_music_started then
			music.main_music_started = true
			music.penta:play()
			music.penta:setLooping(true)
		end

		modes[mode].func_update(dt)

		-- check if an enemy has hit the player
		for i, enemy in pairs(enemies) do
			if collision.collisionTest(player.shape, enemy.shape) then
				sound.player_hit:play()
				player.curr_damage = player.curr_damage + 1
				table.remove(enemies, i)
			end
		end

		-- check if any shot has hit an enemy, regenerate HP!
		for i, shot in pairs(shots) do
			for j, enemy in pairs(enemies) do
				if collision.collisionTest(shot.shape, enemy.shape) then
					if enemy.object_type ~= "invinc" then
						if player.curr_damage > 1 then
							player.curr_damage = player.curr_damage - 1
						end
						sound.enemy_hit:play()
						table.remove(shots, i)
						table.remove(enemies, j)
					end
				end
			end
		end

		if player.curr_damage > player.max_damage then
			lose_game()
		end
	end

end

function love.draw()
	if state == "game_running" then
		modes[mode].func_draw()
		write_right(time_to_string(game_time), small_font, win_w, 5)
	elseif state == "start" then
		show_startscreen()
	elseif state == "info" then
		show_infoscreen()
	else
		show_deathscreen()
	end
end

function start_game()
	state = "game_running"
	init_objects()
	game_time = 0

	enemies_spawned = 0
	last_shot = 0
	music.western:play()
end

function lose_game()
	mode = "mode"..key_see
	music.penta:stop()
	music.main_music_started = false
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
						small_font, 2*win_h / 4, win_w)
		write_centered(hs_holder, small_font, 2.5*win_h / 4, win_w)
	elseif state == "death" then
		write_centered("You died...", big_font, 0.7*win_h / 4, win_w) 
		write_centered("Press <space> to go to the main menu.",
						small_font, 2*win_h / 4, win_w)
	end
end

function show_startscreen()
	-- Setup
	local w = 60
	local h = 40
	local x = (win_w - w) / 2
	local y = 1.7*win_h / 4
	local dist = 90	

	local holder = hs_holder
	if #holder < 1 then holder = "A. Nonymous" end

	-- Print 
	write_centered("Shape Shifter", big_font, 0.7*win_h / 4, win_w)
	write_centered("Current highscore is "..time_to_string(highscore).." seconds, held by "..holder,
					small_font, y + 2*h, win_w)
	write_centered("Press <space> to start game!", small_font, 3.2*win_h / 4, win_w)
	
	love.graphics.rectangle("line", x - dist, y, w, h, w/2, h/2) 
	love.graphics.rectangle("line", x, y, w, h, 0) 
	love.graphics.polygon("line", {
			x + dist, y, 
			x + dist, y + h, 
			x + w + dist, y + h/2}) 
end

function show_infoscreen()
	local w = 60
	local h = 40
	local x = (win_w - w) / 2
	local y = 1.7*win_h / 4
	local dist = 90	

	write_centered("Shift between modes:", medium_font, 0.3*win_h / 4, win_w)
	write_centered("Press", small_font, y - 2.1*w, win_w)

	write("1", small_font, x - 1.1*w, y - 1.4*w)
	write_centered("2", small_font,	y - 1.4*w, win_w)
	write("3", small_font, x + 1.8*w,	y - 1.4*w)

	write_centered("to", small_font, y - dist + 0.7*w, win_w)

	write("see", small_font, x - 1.3*w,	y + 0.9*w)
	write_centered("move", small_font, y + 0.9*w, win_w)
	write("shoot", small_font, x + 1.5*w, y + 0.9*w)

	--write_centered("with", small_font, y + 1.6*w, win_w)

	write_centered("< >  to rotate in see and shoot mode", small_font, y + 2.2*w, win_w)
	write_centered("< ^ ˇ >   to move in move mode", small_font, y + 2.8*w, win_w) 

	love.graphics.rectangle("line", x - dist, y, w, h, w/2, h/2) 
	love.graphics.rectangle("line", x, y, w, h, 0) 
	love.graphics.polygon("line", {
			x + dist, y, 
			x + dist, y + h, 
			x + w + dist, y + h/2}) 
	write_centered("Press <space> to start game (and shoot)!", small_font, 3.2*win_h / 4, win_w)
end
