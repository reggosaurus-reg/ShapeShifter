function draw_rectangle()
	love.graphics.push()
		love.graphics.translate(player.x, player.y)
		love.graphics.rotate(player.rotation)
		love.graphics.rectangle("line", - (player.width / 2), - (player.height / 2), 
				player.width, player.height,
				(player.width / 2) * player.round,
				(player.height / 2) * player.round
		)
	love.graphics.pop()
end

player = {}
player.x = win_w / 2
player.y = win_h / 2
player.x_speed = 300
player.y_speed = 300
player.x_dir = 0
player.y_dir = 0
player.height = 120
player.width = 80
player.rotation = 0  -- radians
player.rotation_dir = 0
player.round = 0;  -- andel, 0 = kvadrat, 1 = cirkel/ellips
player.draw = draw_rectangle

function player.move(dt)
	player.rotation = player.rotation + player.rotation_dir * rotation_speed * dt
	
	-- if player.canMove()
	player.x = player.x + player.x_dir * player.x_speed * dt
	player.y = player.y + player.y_dir * player.y_speed * dt
end

function player.update()

end
