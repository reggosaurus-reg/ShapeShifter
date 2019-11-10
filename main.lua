require("modes")
require("objects")

win_w = 800	
win_h = 600

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
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})
	collider = HC(100, on_collide)
	
	-- Note: mode1 in table is matched with string created in onKeyPressed/initial mode
	modes = {mode1 = mode_see, mode2 = mode_move, mode3 = mode_attack}
	rotation_speed = math.pi * 2  -- half a lap per second

	mode = "mode"..key_see -- initial mode
	player = spawn("player", {x = 60})
	enemies = {}
	shots = {}
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
		shot_args = {}
		shot_args.x = player.x
		shot_args.y = player.y
		shot_args.rotation = player.rotation - math.pi / 2
		shots[#shots + 1] = spawn("shot", shot_args)
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

function get_type_from_shape(shape, objects)
	for i, object in objects do
		if object.shape == shape then return object.object_type end
	end
	return nil
end

function on_collide(dt, shape_a, shape_b)
	print("colliding!")
	if get_type_from_shape(shape_a) == "enemy" or get_type_from_shape(shape_b) == "enemy" then
		if get_type_from_shape(shape_a) == "player" or get_type_from_shape(shape_b) == "player" then
			print("colliding player")
		elseif get_type_from_shape(shape_a) == "shot" or get_type_from_shape(shape_b) == "shot" then
				print("colliding shot")
		end
	end
end

function love.update(dt)
	print(collider)
	collider:update(dt)
	
	-- TODO: Move those calls into modes
	modes[mode].func_update(dt)
	for i, enemy in pairs(enemies) do
		enemy:move(dt)
		enemy:update()
	end

	for i, shot in pairs(shots) do
		shot:move(dt)
		shot:update()
	end
end

function love.draw()
	modes[mode].func_draw()

	-- TODO: Move those draw-calls into modes
	for i, enemy in pairs(enemies) do
		enemy:draw()
	end

	for i, shot in pairs(shots) do
		shot:draw()
	end
end

