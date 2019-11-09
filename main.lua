-- KEYMAP
stretch_pos = "j"
stretch_neg = "k"
round_inc = "l"
round_dec = "h"
rot_l = "a"
rot_r = "d"

win_w = 1000
win_h = 1000

stretch_speed = 600
round_speed = 2
rotation_speed = math.pi * 2  -- half a lap per second

function love.load()
	love.window.setMode(win_w, win_h, {resizable=false, vsync=true, highdpi=true})
	player = {}
	player.diameter = 200
	player.height = player.diameter / 2
	player.width = player.diameter / 2
	player.x = 0
	player.y = 0
	player.rot = 0  -- radians
	player.round = 0;  -- andel, 0 = kvadrat, 1 = cirkel/ellips

end

function calcPlayer()
	player.x = (win_h - player.width) / 2
	player.y = (win_w - player.height) / 2
end

function love.keypressed(key)
	if key == "space" then
		print(player.width)
		print(player.width / 2)
		print(player.height)
		print(player.height / 2)
		print(player.rot)
	end
end

function love.update(dt)
	-- PLAYER 
	-- rectangle/square
	if love.keyboard.isDown(stretch_pos) then
		player.width = player.width + stretch_speed * dt
	elseif love.keyboard.isDown(stretch_neg) then
		player.width = player.width - stretch_speed * dt
	end
	player.width = math.min(math.max(player.diameter / 10, player.width), player.diameter * (9 / 10))
	player.height = player.diameter - player.width
	
	-- roundness
	if love.keyboard.isDown(round_inc) then
		player.round = player.round + round_speed * dt
	elseif love.keyboard.isDown(round_dec) then
		player.round = player.round - round_speed * dt
	end
	player.round = math.min(math.max(0, player.round), 1)

	-- rotation
	if love.keyboard.isDown(rot_r) then
		player.rot = player.rot + rotation_speed * dt
	elseif love.keyboard.isDown(rot_l) then
		player.rot = player.rot - rotation_speed * dt
	end
	calcPlayer()

	-- SHOTS
end

draw_player = true
draw_shots = false

function love.draw()
	if draw_player == true then
		love.graphics.push()
			love.graphics.translate(win_w / 2, win_h / 2)
			love.graphics.rotate(player.rot)
			love.graphics.rectangle("line", - (player.width / 2), - (player.height / 2), 
					player.width, player.height,
					(player.width / 2) * player.round,
					(player.height / 2) * player.round
			)
		love.graphics.pop()
	end

	if draw_shots == true then
		
	end
end

