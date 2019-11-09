win_w = 800	
win_h = 600

require("objects")
require("modes")

-- KEYMAP
rot_l = "j"
rot_r = "k"
inc_x = "d"
dec_x = "a"
inc_y = "w"
dec_y = "s"
mode_see = "1"
mode_move = "2"
mode_attack = "3"

round_speed = 2
rotation_speed = math.pi * 2  -- half a lap per second

function love.load()
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})

	-- Note: mode1 in table is matched with string created in onKeyPressed/initial mode
	modes = {mode1 = see, mode2 = move, mode3 = attack}
	mode = "mode"..mode_attack -- initial mode
end

function love.keypressed(key)
	-- Window management
	if key == "escape" then
		love.event.quit()
	end

	-- Modes
	if key == mode_see or key == mode_move or key == mode_attack then
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
end

function love.keyreleased(key)
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

function love.update(dt)
	player:move(dt)
	enemy:move(dt)
	player:update()
end

function love.draw()
	modes[mode].draw()
end

