-- A file holding the collision code. Checking circles and rects.
local collision = {}

function collision.makeRect(w, h)
	local rect = {collision_type = "rectangle", x = 0, y = 0, width = w, height = h}
	return rect
end

function collision.makeCircle(r)
	local circle = {collision_type = "circle", x = 0, y = 0, radius = r}
	return circle
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
			return { x = math.sign(a.x - b.x), y = 0 }
		else
			return { x = 0, y = math.sign(a.y - b.y) }
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
