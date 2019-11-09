require("player")

-- KEYMAP
rot_l = "j"
rot_r = "k"

win_w = 800	
win_h = 800

stretch_speed = 600
round_speed = 2
rotation_speed = math.pi * 2  -- half a lap per second

function love.load()
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	if key == rot_r then
		player.rotation_dir = player.rotation_dir + 1
	elseif key == rot_l then
		player.rotation_dir = player.rotation_dir - 1
	end
end

function love.keyreleased(key)
	if key == rot_r then
		player.rotation_dir = player.rotation_dir - 1
	elseif key == rot_l then
		player.rotation_dir = player.rotation_dir + 1
	end
end

function love.update(dt)
	player.rotation = player.rotation + player.rotation_dir * rotation_speed * dt

	player.update()
end

draw_player = true
draw_shots = false

function love.draw()
	if draw_player == true then
		player.draw()
	end

	if draw_shots == true then
		
	end
end
