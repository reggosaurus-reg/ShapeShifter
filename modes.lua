require("objects")
require("functions")

mode_see = {
	func_draw = function() 
		draw_ellipse(player)
		draw_shot()
		draw_enemies()
	end,
	func_key_pressed = rotate_on_key,
	func_key_released = stop_rotate_on_key,
	func_update = function(dt) 
		reset_movements()
		player:rotate(dt)
		update(player)
		update_other_objects(dt)
	end,
	func_shoot = function()
	end
}

mode_move = {
	func_draw = function() 
		draw_rectangle(player) 
	end,
	func_key_pressed = move_on_key,
	func_key_released = stop_move_on_key,
	func_update = function(dt) 
		reset_rotations()
		player:move(dt)
		update(player)
		update_other_objects(dt)
	end,
	func_shoot = function()
	end
}

last_shot = 0

mode_attack = {
	func_draw = function() 
		draw_triangle(player) 
		draw_shot()
	end,
	func_key_pressed = rotate_on_key,
	func_key_released = stop_rotate_on_key,
	func_update = function(dt) 
		reset_movements()
		rotate(player, dt)
		update(player)
		update_other_objects(dt)
	end,
	func_shoot = function()
		if game_time - last_shot > shot_interval then
			last_shot = game_time
			spawn_shot()
			sound_shoot:play()
		end
	end
}

function draw_shot()
	for i, shot in pairs(shots) do
		shot:draw()
	end
end

function draw_enemies()
	for i, enemy in pairs(enemies) do
		enemy:draw()
	end
end

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
		sound_enemy_spawn:play()
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

