c = require("collision")

function get_value(table, arg, default)
	if table[arg] ~= nil then return table[arg] else return default end
end

-- Spawn object
function spawn(object_type, args)
	if object_type == "player" then
		local player = {}
		player.object_type = object_type
		player.x = get_value(args, "x", win_w / 2)
		player.y = get_value(args, "y", win_h / 2)
		player.x_speed = get_value(args, "x_speed", 300)
		player.y_speed = get_value(args, "y_speed", 300)
		player.x_dir = 0
		player.y_dir = 0
		player.height = get_value(args, "height", 60)
		player.width = get_value(args, "width", 60)
		player.rotation = 0
		player.rotation_dir = 0
		player.round = 0
		player.filling = "line"
		player.shape = c.makeRect(player.x, player.y, player.width, player.height)
		player.move = get_value(args, "move", move)
		player.rotate = get_value(args, "rotate", rotate)
		player.update = get_value(args, "update", update)
		player.draw = get_value(args, "draw", draw_rectangle)
		return player
	elseif object_type == "enemy" then
		enemy = {}
		enemy.object_type = object_type
		enemy.x = get_value(args, "x", 0) 
		enemy.y = get_value(args, "y", 0)
		enemy.x_speed = get_value(args, "x_speed", 100)
		enemy.y_speed = get_value(args, "y_speed", 100)
		enemy.x_dir = 1
		enemy.y_dir = 1
		enemy.height = get_value(args, "height", 80) 
		enemy.width = get_value(args, "width", 80)
		enemy.rotation = get_value(args, "rotation", 0)
		enemy.rotation_dir = 0
		enemy.round = 0 
		enemy.filling = "fill"
		enemy.shape = c.makeRect(enemy.x, enemy.y, enemy.width, enemy.height)
		enemy.draw = get_value(args, "draw", draw_rectangle)
		enemy.move = get_value(args, "move", move)
		enemy.update = get_value(args, "update", update)
	elseif object_type == "shot" then
		local shot = {}
		shot.object_type = object_type
		shot.x = get_value(args, "x", 200)
		shot.y = get_value(args, "y", 200)
		shot.x_dir = 1
		shot.y_dir = 1
		shot.rotation = get_value(args, "rotation", 0)
		shot.speed = get_value(args, "speed", 400)
		shot.x_speed = shot.speed * math.cos(shot.rotation)
		shot.y_speed = shot.speed * math.sin(shot.rotation)
		shot.radius = get_value(args, "radius", 8)
		shot.width = shot.radius * 2
		shot.height = shot.radius * 2
		shot.round = 1
		shot.filling = "fill"
		shot.shape = c.makeCircle(shot.x, shot.y, shot.radius)
		shot.move = get_value(args, "move", move)
		shot.update = get_value(args, "update", update)
		shot.draw = get_value(args, "draw", draw_rectangle)
		return shot
	end
end


-- Draw functions

function draw_rectangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		love.graphics.rectangle(object.filling, - (object.width / 2), - (object.height / 2), 
				object.width, object.height,
				(object.width / 2) * object.round,
				(object.height / 2) * object.round
		)
	love.graphics.pop()
end

function draw_ellipse(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		love.graphics.rectangle(object.filling, - (object.width / 2), - (object.height / 2), 
				object.width, object.height,
				(object.width / 2),
				(object.height / 2)
		)
	love.graphics.pop()
end

function draw_triangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		vertices = {0, - object.height / 2,  
					object.width / 2,  object.height / 2,
					- object.width / 2,  object.height / 2}
		love.graphics.polygon(object.filling, vertices)
	love.graphics.pop()
end

-- Update functions

function rotate(object, dt)
	object.rotation = object.rotation + object.rotation_dir * rotation_speed * dt
end

function move(object, dt)
	-- if object.canMove()
	object.x = object.x + object.x_dir * object.x_speed * dt
	object.y = object.y + object.y_dir * object.y_speed * dt

	c.moveTo(object.shape, object.x, object.y)
end

function update(object)

end
