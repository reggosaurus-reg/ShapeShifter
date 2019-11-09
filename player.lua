function draw_rectangle()
	love.graphics.push()
	love.graphics.translate(win_w / 2, win_h / 2)
	love.graphics.rotate(player.rotation)
	love.graphics.rectangle("line", - (player.width / 2), - (player.height / 2), 
	player.width, player.height,
	(player.width / 2) * player.round,
	(player.height / 2) * player.round
	)
	love.graphics.pop()
end

player = {}
player.x = 0
player.x_dir = 0
player.y = 0
player.y_dir = 0
player.diameter = 200
player.height = player.diameter / 2
player.width = player.diameter / 2
player.rotation = 0  -- radians
player.rotation_dir = 0
player.round = 0;  -- andel, 0 = kvadrat, 1 = cirkel/ellips
player.draw = draw_rectangle
function player.move(x, y, rot)

end

function player.update()
	player.x = (win_h - player.width) / 2
	player.y = (win_w - player.height) / 2
end
