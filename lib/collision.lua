-- A file holding the collision code. Checking circles and rects.
local collision = {}

function collision.makeRect(x, y, w, h)
	local rect = {collision_type = "rectangle", x = x - w / 2, y = y - h / 2, width = w, height = h}
	return rect
end

function collision.makeCircle(x, y, r)
	local circle = {collision_type = "circle", x = x - r, y = y - r, radius = r}
	return circle
end

function collision.moveTo(shape, x, y)
	if shape.collision_type == "rectangle" then
		shape.x = x - shape.width / 2
		shape.y = y - shape.height / 2
	elseif shape.collision_type == "circle" then
		shape.x = x - shape.radius
		shape.y = y - shape.radius
	end
end

function collision.collisionTest(a, b)
	if a.collision_type == "rectangle" 
		and b.collision_type == "rectangle" then
		-- Rectangle VS Rectangle
		local diffX = math.abs((a.x + a.width / 2) - (b.x + b.width / 2)) 
						- (a.width + b.width) / 2
		if diffX > 0 then return false end
		local diffY = math.abs((a.y + a.height / 2) - (b.y + b.height / 2)) 
						- (a.height + b.height) / 2
		if diffY > 0 then return false end
		if diffX < diffY then
			return true
		else
			return true
		end
	end
	if a.collision_type == "circle" 
		and b.collision_type == "circle" then
		-- Circle VS Circle
		local diffX = a.x - b.x
		local diffY = a.y - b.y
		local radiusSquared = (a.radius + b.radius) * (a.radius + b.radius)
		return diffX * diffX + diffY * diffY < radiusSquared
	end
	-- Circle vs rectangle case
	local rect = nil
	local circle = nil
	if a.collision_type == "rectangle" then
		rect = a
		circle = b
	else
		rect = b
		circle = a
	end
	local nearestX = math.clamp(circle.x, 
	rect.x, 
	rect.x + rect.width)
	local nearestY = math.clamp(circle.y, 
	rect.y, 
	rect.y + rect.height)
	love.graphics.setColor(1, 1, 1)
	love.graphics.circle("fill", nearestX, nearestY, 10)
	local diffX = circle.x - nearestX
	local diffY = circle.y - nearestY
	local dSq = diffX * diffX + diffY * diffY
	local rSq = circle.radius * circle.radius
	return dSq < rSq
end

return collision
