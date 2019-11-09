win_w = 800	
win_h = 600

require("objects")

-- KEYMAP
rot_l = "j"
rot_r = "k"
inc_x = "d"
dec_x = "a"
inc_y = "w"
dec_y = "s"

stretch_speed = 600
round_speed = 2
rotation_speed = math.pi * 2  -- half a lap per second

enemies = {}
shots = {}

function love.load()
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})
	player_args = {}
	player_args.x = 10
	player = spawn("player", player_args)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

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
		shot_args = {}
		shot_args.x = player.x
		shot_args.y = player.y
		shot_args.rotation = player.rotation + math.pi / 2
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

function love.update(dt)
	player:move(dt)
	player:update()

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
	player:draw()

	for i, enemy in pairs(enemies) do
		enemy:draw()
	end

	for i, shot in pairs(shots) do
		shot:draw()
	end
end

