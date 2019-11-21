function get_value(table, arg, default)
	if table[arg] ~= nil then return table[arg] else return default end
end

function rotate(object, dt)
	object.rotation = object.rotation + object.rotation_dir * object.rotation_speed * dt
end

function random_of_two(a, b)
	if math.random(0, 1) == 0 then
		return a
	else 
		return b
	end
end

math.clamp = function(lo, val, hi)
	return math.min(math.max(lo, val), hi)
end
