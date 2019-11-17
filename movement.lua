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

		function reset_rotations()
			player.rotation_dir = 0
			if pressed_keys.right == "rot" then
				pressed_keys.right = "none"
				move_on_key(key_right)
			end
			if pressed_keys.left == "rot" then
				pressed_keys.left = "none"
				move_on_key(key_left)
			end
		end

		function reset_movements()
			player.x_dir = 0 
			player.y_dir = 0 
			if pressed_keys.right == "move" then
				pressed_keys.right = "none"
				rotate_on_key(key_right)
			end
			if pressed_keys.left == "move" then
				pressed_keys.left = "none"
				rotate_on_key(key_left)
			end
			if pressed_keys.down == "move" then
				pressed_keys.down = "none"
			end
			if pressed_keys.up == "move" then
				pressed_keys.up = "none"
			end
		end

		function rotate_on_key(key)
			if key == key_right and pressed_keys.right ~= "move" then
				player.rotation_dir = player.rotation_dir + 1
				pressed_keys.right = "rot"
			elseif key == key_left and pressed_keys.left ~= "move" then
				player.rotation_dir = player.rotation_dir - 1
				pressed_keys.left = "rot"
			end
		end

		function move_on_key(key)
			if key == key_right and pressed_keys.right ~= "rot" then
				player.x_dir = player.x_dir + 1
				pressed_keys.right = "move"
			elseif key == key_left and pressed_keys.left ~= "rot" then
				player.x_dir = player.x_dir - 1
				pressed_keys.left = "move"
			elseif key == key_down and pressed_keys.down ~= "rot" then
				player.y_dir = player.y_dir + 1
				pressed_keys.down = "move"
			elseif key == key_up and pressed_keys.up ~= "rot" then
				player.y_dir = player.y_dir - 1
				pressed_keys.up = "move"
			end
		end

		function stop_rotate_on_key(key)
			if key == key_right and pressed_keys.right == "rot" then
				player.rotation_dir = player.rotation_dir - 1
				pressed_keys.right = "none"
			elseif key == key_left and pressed_keys.left == "rot" then
				player.rotation_dir = player.rotation_dir + 1
				pressed_keys.left = "none"
			end
		end

		function stop_move_on_key(key)
			if key == key_right and pressed_keys.right == "move" then
				player.x_dir = player.x_dir - 1
				pressed_keys.right = "none"
			elseif key == key_left and pressed_keys.left == "move" then
				player.x_dir = player.x_dir + 1
				pressed_keys.left = "none"
			elseif key == key_down and pressed_keys.down == "move" then
				player.y_dir = player.y_dir - 1
				pressed_keys.down = "none"
			elseif key == key_up and pressed_keys.up == "move" then
				player.y_dir = player.y_dir + 1
				pressed_keys.up = "none"
			end
		end
