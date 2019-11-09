require("objects")
require("modes")

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
	game_running = false
	
	-- Note: mode1 in table is matched with string created in onKeyPressed/initial mode
	modes = {mode1 = mode_see, mode2 = mode_move, mode3 = mode_attack}
	rotation_speed = math.pi * 2  -- half a lap per second

	mode = "mode"..key_see -- initial mode

end

function love.keypressed(key)
	-- Window management
	if key == "escape" then
		love.event.quit()
	end

	if game_running then
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

	else
		if key == "space" or key == "return" then
			game_running = true
			init_objects()
		end
	end
end

function love.keyreleased(key)
	if game_running then
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
	if game_running then
		modes[mode].func_update(dt)
	end
end

function love.draw()
	if game_running then
		modes[mode].func_draw()
	else
		show_startscreen()
	end
end

function show_startscreen()
	big_font = love.graphics.newFont(55)
	small_font = love.graphics.newFont(15)
	local title = "ShapeShifter"
	local start_text = "Press <space> to start game!"
	local w_title = big_font:getWidth(title)
	local w_text = small_font:getWidth(start_text)
	love.graphics.setFont(big_font)
	love.graphics.print(title, (win_w - w_title) / 2, win_h / 4)
	love.graphics.setFont(small_font)
	love.graphics.print(start_text, (win_w - w_text) / 2, 3*win_h / 4)

	-- TODO: Only looks good on my screen - make relative window size
	local w = 60
	local h = 40
	local x = (win_w - w_title) / 2 + 50
	local y = 2*win_h / 4
	local dist = 90	
	love.graphics.rectangle("line", x, y, w, h, w/2, h/2) 
	love.graphics.rectangle("line", x + dist, y, w, h, 0, 0) 
	love.graphics.polygon("line", {x + 2*dist, y, 
									x + 2*dist, y + h, 
									x + 2*dist + w, y + h/2}) 
end
