c = require("lib/collision")
require("lib/graphics")
require("lib/helpers")
require("movement")

enemy_spawn_interval = 2
enemies_spawned = 0

shot_interval = 1
last_shot = 0

-- Spawn object
function spawn(object_type, args)
	if object_type == "player" then
		local player = {}
		player.curr_damage = 1
		player.draw = get_value(args, "draw", draw_rectangle)
		player.filling = "line"
		player.height = get_value(args, "height", 60)
		player.width = get_value(args, "width", 60)
		player.max_damage = 4
		player.move = get_value(args, "move", move_player)
		player.object_type = object_type
		player.rotate = get_value(args, "rotate", rotate)
		player.rotation = 0
		player.rotation_dir = 0
		player.rotation_speed = math.pi * 2
		player.round = 0
		player.update = get_value(args, "update", update)
		player.x = get_value(args, "x", win_w / 2)
		player.x_dir = 0
		player.x_speed = get_value(args, "x_speed", 300)
		player.y = get_value(args, "y", win_h / 2)
		player.y_dir = 0
		player.y_speed = get_value(args, "y_speed", 300)

		player.shape = c.makeRect(player.x, player.y, player.width, player.height)
		return player
	elseif object_type == "enemy" then
		local enemy = {}
		enemy.draw = get_value(args, "draw", draw_single_rectangle)
		enemy.filling = "fill"
		enemy.height = get_value(args, "height", 80) 
		enemy.width = get_value(args, "width", 80)
		enemy.min_speed = 100
		enemy.max_speed = 200
		enemy.move = get_value(args, "move", move_enemy)
		enemy.object_type = object_type
		enemy.rotation = get_value(args, "rotation", 0)
		enemy.rotation_dir = 0
		enemy.round = 0 
		enemy.update = get_value(args, "update", update)
		enemy.x = get_value(args, "x", 0) 
		enemy.x_dir = get_value(args, "x_dir", 1)
		enemy.y = get_value(args, "y", 0)
		enemy.y_dir = get_value(args, "y_dir", 1)

		enemy.shape = c.makeRect(enemy.x, enemy.y, enemy.width, enemy.height)
		enemy.x_speed = get_value(args, "x_speed",
				math.random(enemy.min_speed, enemy.max_speed))
		enemy.y_speed = get_value(args, "y_speed",
				math.random(enemy.min_speed, enemy.max_speed))
		return enemy
	elseif object_type == "shot" then
		local shot = {}
		shot.draw = get_value(args, "draw", draw_ellipse)
		shot.filling = "fill"
		shot.move = get_value(args, "move", move_shot)
		shot.object_type = object_type
		shot.radius = get_value(args, "radius", 8)
		shot.rotation = get_value(args, "rotation", 0)
		shot.round = 1
		shot.speed = get_value(args, "speed", 400)
		shot.update = get_value(args, "update", update)
		shot.x = get_value(args, "x", 200)
		shot.x_dir = 1
		shot.y = get_value(args, "y", 200)
		shot.y_dir = 1

		shot.height = shot.radius * 2
		shot.width = shot.radius * 2
		shot.shape = c.makeCircle(shot.x, shot.y, shot.radius)
		shot.x_speed = shot.speed * math.cos(shot.rotation)
		shot.y_speed = shot.speed * math.sin(shot.rotation)
		return shot
	end
end

-- Creation functions 

function init_objects()
	player = spawn("player", {height = 70})
	enemies = {}
	shots = {}

	start_time = love.timer.getTime()
end

function spawn_shot()
	local args = {}
	args.x = player.x
	args.y = player.y
	args.rotation = player.rotation - math.pi/2
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
	if args.x < win_w/2 then
		args.x_dir = 1
	else
		args.x_dir = -1
	end

	if args.y < win_h/2 then
		args.y_dir = 1
	else
		args.y_dir = -1
	end

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

function update(entity) end

function update_other_objects(dt)
	to_remove = {}
	for i, shot in pairs(shots) do
		if shot:move(dt) == false then
			to_remove[#to_remove + 1] = i
		end
		shot:update()
	end
	for i, num in pairs(to_remove) do
		table.remove(shots, i)
	end
	if enemies_spawned < math.floor(game_time / enemy_spawn_interval) then
		-- e.g. game_time = 6.01 => game_time / enemy_interval = 3.005
		-- so if enemies_spawned == 2 then spawn 
		sound.enemy_spawn:play()
		enemies_spawned = enemies_spawned + 1
		if game_time > 60 then
			enemies[#enemies + 1] = random_of_two(spawn_enemy(), spawn_invinc_enemy())
		else
			enemies[#enemies + 1] = spawn_enemy()
		end
	end
	to_remove = {}
	for i, enemy in pairs(enemies) do
		if enemy:move(dt) == false then
			to_remove[#to_remove + 1] = i
		end
		enemy:update()
	end
	for i, num in pairs(to_remove) do
		table.remove(enemies, i)
	end
end

