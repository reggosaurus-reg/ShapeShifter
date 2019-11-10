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
		rotate(player, dt)
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
		move(player,dt) 
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
	for i, shot in pairs(shots) do
		shot:move(dt)
		shot:update()
	end
	if enemies_spawned < math.floor(game_time / enemy_spawn_interval) then
		-- e.g. game_time = 6.01 => game_time / enemy_interval = 3.005
		-- so if enemies_spawned == 2 then spawn 
		enemies_spawned = enemies_spawned + 1
		spawn_enemy()
	end
	for i, enemy in pairs(enemies) do
		enemy:move(dt)
		enemy:update()
	end
end

