c = require("collision")
require("values")

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
		player.move = get_value(args, "move", move_player)
		player.rotate = get_value(args, "rotate", rotate)
		player.update = get_value(args, "update", update)
		player.draw = get_value(args, "draw", draw_rectangle)
		return player
	elseif object_type == "enemy" then
		local enemy = {}
		enemy.object_type = object_type
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
		enemy.shape = c.makeRect(enemy.x, enemy.y, enemy.width, enemy.height)
		enemy.draw = get_value(args, "draw", draw_single_rectangle)
		enemy.move = get_value(args, "move", move_enemy)
		enemy.update = get_value(args, "update", update)
		return enemy
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
		shot.move = get_value(args, "move", move_shot)
		shot.update = get_value(args, "update", update)
		shot.draw = get_value(args, "draw", draw_ellipse)
		return shot
	end
end

-- Creation functions 

function init_objects()
	player = spawn("player", {height = 70})
	curr_damage = 1

	enemies = {}
	start_time = love.timer.getTime()
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

	return spawn("enemy", args)
end

function spawn_invinc_enemy()
	local enemy = spawn_enemy()
	enemy.object_type = "invinc"
	enemy.filling = "line"
	enemy.x_speed = enemy.x_speed * 2
	enemy.y_speed = enemy.y_speed * 2
	return enemy
end

-- Draw functions
function draw_rectangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		function sub_rectangle(x, y, w, h)
			love.graphics.rectangle(object.filling, x, y, w, h)
		end
		draw_subs(object, sub_rectangle)
	love.graphics.pop()
end

function draw_single_rectangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		love.graphics.rectangle(object.filling, - (object.width / 2), - (object.height / 2), object.width, object.height)
	love.graphics.pop()
end

function draw_ellipse(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		function sub_ellipse(x, y, w, h)
			love.graphics.rectangle(object.filling, x, y, w, h, 
									object.width / 2, object.height / 2)
		end
		draw_subs(object, sub_ellipse)
	love.graphics.pop()
end

function draw_triangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		local w0 = object.width / 2
		local h0 = object.height / 2
		for hurt = curr_damage, max_damage do
			local s = 1 - hurt / max_damage
			local diff = 1.1
			vertices = {0, - h0 + diff*s*h0,
						w0 - diff*s*w0, h0 - s*h0,
						- w0 + diff*s*w0, h0 - s*h0}
			love.graphics.polygon(object.filling, vertices)
		end
	love.graphics.pop()
end

function draw_subs(object, func)
	local x0 = - (object.width / 2)
	local y0 = - (object.height / 2)
	local w0 = object.width
	local h0 = object.height
	for hurt = curr_damage, max_damage do
		local p = hurt / max_damage
		func(x0 + w0/2 * (1-p), y0 + h0/2 * (1-p), w0 * p, h0 * p)
	end
end

-- Update functions

function rotate(object, dt)
	object.rotation = object.rotation + object.rotation_dir * rotation_speed * dt
end

function move_player(player, dt)
	if (player.x + player.x_dir * player.x_speed * dt) + player.width / 2 > win_w then
		player.x = win_w - player.width / 2
		return false
	elseif player.x + player.x_dir * player.x_speed * dt < player.width / 2 then
		player.x = player.width / 2
		return false
	end

	if (player.y + player.y_dir * player.y_speed * dt) + player.height / 2 > win_h then
		-- TODO player gets "stuck" here
		return false
	elseif player.y + player.y_dir * player.y_speed * dt < player.height / 2 then
		player.y = player.height / 2
		return false
	end
	move(player, dt)
	return true
end

function move_shot(shot, dt)
	if shot.x - shot.radius > win_w or shot.x + shot.radius < 0 or 
			shot.y - shot.radius > win_h or shot.y + shot.radius < 0 then return false end
	move(shot, dt)
	return true
end

function move_enemy(enemy, dt)
	if enemy.x - enemy.width * 2 > win_w or
			enemy.y - enemy.height * 2 > win_h or
			enemy.x + enemy.width * 2 < 0 or
			enemy.y + enemy.height * 2 < 0 then return false end
	move(enemy, dt)
	return true
end

function move(object, dt)
	-- if object.canMove()
	object.x = object.x + object.x_dir * object.x_speed * dt
	object.y = object.y + object.y_dir * object.y_speed * dt

	c.moveTo(object.shape, object.x, object.y)
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
