function get_value(table, arg, default)
	if table[arg] ~= nil then return table[arg] else return default end
end

-- Spawn object
function spawn(object_type, args)
	if object_type == "player" then
		local player = {}
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
		player.move = get_value(args, "move", move)
		player.rotate = get_value(args, "rotate", rotate)
		player.update = get_value(args, "update", update)
		player.draw = get_value(args, "draw", draw_rectangle)
		return player
	elseif object_type == "enemy" then
		enemy = {}
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
		enemy.round = 1 
		enemy.draw = get_value(args, "draw", draw_rectangle)
		enemy.move = get_value(args, "move", move)
		enemy.update = get_value(args, "update", update)
	elseif object_type == "shot" then
		local shot = {}
		shot.x = get_value(args, "x", 200)
		shot.y = get_value(args, "y", 200)
		shot.x_dir = 1
		shot.y_dir = 1
		shot.rotation = get_value(args, "rotation", 0)
		shot.speed = get_value(args, "speed", 400)
		shot.x_speed = shot.speed * math.cos(shot.rotation)
		shot.y_speed = shot.speed * math.sin(shot.rotation)
		shot.width = get_value(args, "width", 20)
		shot.height = get_value(args, "height", 20)
		shot.round = 0
		shot.move = get_value(args, "move", move)
		shot.update = get_value(args, "update", update)
		shot.draw = get_value(args, "draw", draw_rectangle)
		return shot
	end
	-- if args.x != nil then x = args.x else x = 25 end
end


-- Draw functions

function draw_rectangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		love.graphics.rectangle("line", - (object.width / 2), - (object.height / 2), 
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
		love.graphics.rectangle("line", - (object.width / 2), - (object.height / 2), 
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
		love.graphics.polygon("line", vertices)
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
end

function update(object)

end
