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
		player.filling = "line"
		player.move = get_value(args, "move", move)
		player.rotate = get_value(args, "rotate", rotate)
		player.update = get_value(args, "update", update)
		player.draw = get_value(args, "draw", draw_rectangle)
		return player
	elseif object_type == "enemy" then
		local enemy = {}
		enemy.x = get_value(args, "x", 0) 
		enemy.y = get_value(args, "y", 0)
		enemy.x_speed = get_value(args, "x_speed", 100)
		enemy.y_speed = get_value(args, "y_speed", 100)
		enemy.x_dir = get_value(args, "x_dir", 1)
		enemy.y_dir = get_value(args, "y_dir", 1)
		enemy.height = get_value(args, "height", 80) 
		enemy.width = get_value(args, "width", 80)
		enemy.rotation = get_value(args, "rotation", 0)
		enemy.rotation_dir = 0
		enemy.round = 0 
		enemy.filling = "fill"
		enemy.draw = get_value(args, "draw", draw_rectangle)
		enemy.move = get_value(args, "move", move)
		enemy.update = get_value(args, "update", update)
		return enemy
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
		shot.width = get_value(args, "width", 16)
		shot.height = get_value(args, "height", 16)
		shot.round = 1
		shot.filling = "fill"
		shot.move = get_value(args, "move", move)
		shot.update = get_value(args, "update", update)
		shot.draw = get_value(args, "draw", draw_rectangle)
		return shot
	end
	-- if args.x != nil then x = args.x else x = 25 end
end

-- Creation functions 

function init_objects()
	player = spawn("player", {x = 60})

	enemies = {}
	enemy_interval = 2 -- Seconds between enemy spawning
	start_time = love.timer.getTime() -- Can use getMicroTime for microsessions
	min_speed = 100
	max_speed = 200

	shots = {}
end

function spawn_shot()
	local args = {}
	args.x = player.x
	args.y = player.y
	args.rotation = player.rotation - math.pi / 2
	shots[#shots + 1] = spawn("shot", args)
end

function spawn_enemy()
	local args = {}

	-- to only spawn on borders
	math.randomseed(os.time())
	wall_or_roof = random_of_two(0, 1) 
	left_or_right = random_of_two(0, 1)
	--- wall
	if wall_or_roof == 0 then
		args.x = random_of_two(0, win_w)
		args.y = math.random(win_h)
	--- roof
	else 
		args.x = math.random(win_w)
		args.y = random_of_two(0, win_h)
	end

	-- to move towards the other end of the screen
	if args.x < win_w / 2 then
		args.x_dir = 1
	else
		args.x_dir = -1
	end

	if args.y < win_h / 2 then
		args.y_dir = 1
	else
		args.y_dir = -1
	end
	
	args.x_speed = math.random(min_speed, max_speed) -- TODO: Change max/ min when "levelup"
	args.y_speed = math.random(min_speed, max_speed)

	enemies[#enemies + 1] = spawn("enemy", args)

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
end

function update(object)

end

function random_of_two(a, b)
	if math.random(0, 1) == 0 then
		return a
	else 
		return b
	end
end
