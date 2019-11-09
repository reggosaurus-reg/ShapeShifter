require("objects")

mode_see = {
	func_draw = function() 
		love.graphics.print("SEE", 0, 0)
		draw_ellipse(player)
		draw_shot()
		draw_enemies()
	end,
	func_update = function(dt) 
		rotate(player, dt)
		update(player)
		update_other_objects(dt)
	end,
	func_shoot = function()
	end
}

mode_move = {
	func_draw = function() 
		love.graphics.print("MOVE", 0, 0)
		draw_rectangle(player) 
	end,
	func_update = function(dt) 
		move(player,dt) 
		rotate(player, dt)
		update(player)
		update_other_objects(dt)
	end,
	func_shoot = function()
	end
}

mode_attack = {
	func_draw = function() 
		love.graphics.print("ATTACK", 0, 0)
		draw_triangle(player) 
		draw_shot()
		draw_enemies()
	end,
	func_update = function(dt) 
		rotate(player, dt)
		update(player)
		update_other_objects(dt)
	end,
	func_shoot = function()
		spawn_shot()
		spawn_enemy() -- TODO: Move into some interval function
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
	for i, enemy in pairs(enemies) do
		enemy:move(dt)
		enemy:update()
	end
end
