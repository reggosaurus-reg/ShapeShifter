require("values")

function write_centered(text, font, y, win)
	local w = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.print(text, (win - w) / 2, y)
end

function write_right(text, font, win_w, margin)
	local w = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.print(text, win_w - w - 2*margin, margin)
end

function time_to_string(time)
	time = math.ceil((time * 100)) / 100
	local time = ""..time
	if #time == 1 then
		return time..".00"
	elseif #time== 3 then
		return time.."0"
	else 
		return time
	end
end
 
-- Used by modes to move player

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
