require("entities")
require("lib/graphics")
require("movement")

mode_see = {
	func_draw = function() 
		draw_ellipse(player)
		draw_shot(shots)
		draw_enemies(enemies)
	end,
	func_key_pressed = rotate_on_key,
	func_key_released = stop_rotate_on_key,
	func_update = function(dt) 
		reset_movements()
		player:rotate(dt)
		player:update()
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
		player:update()
		update_other_objects(dt)
	end,
	func_shoot = function()
	end
}

mode_attack = {
	func_draw = function() 
		draw_triangle(player) 
		draw_shot(shots)
	end,
	func_key_pressed = rotate_on_key,
	func_key_released = stop_rotate_on_key,
	func_update = function(dt) 
		reset_movements()
		player:rotate(dt)
		player:update()
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
