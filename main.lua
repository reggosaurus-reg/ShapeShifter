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
	
	-- Note: mode1 in table is matched with string created in onKeyPressed/initial mode
	modes = {mode1 = mode_see, mode2 = mode_move, mode3 = mode_attack}
	rotation_speed = math.pi * 2  -- half a lap per second

	init_objects()
	mode = "mode"..key_see -- initial mode

end

function love.keypressed(key)
	-- Window management
	if key == "escape" then
		love.event.quit()
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

	-- TODO: Only when in attack mode
	if key == "space" then
		modes[mode].func_shoot()
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
	modes[mode].func_update(dt)

end

function love.draw()
	modes[mode].func_draw()

	-- TODO: Move those draw-calls into modes
	for i, enemy in pairs(enemies) do
		enemy:draw()
	end

end

