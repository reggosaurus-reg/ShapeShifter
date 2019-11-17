function draw_shot(shots)
	for i, shot in pairs(shots) do
		shot:draw()
	end
end

function draw_enemies(enemies)
	for i, enemy in pairs(enemies) do
		enemy:draw()
	end
end

-- Draw shapes
function draw_rectangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		function sub_rectangle(x, y, w, h)
			love.graphics.rectangle(object.filling, x, y, w, h)
		end
		draw_subs(object, sub_rectangle)
	love.graphics.pop()
end

function draw_single_rectangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		love.graphics.rectangle(object.filling, - (object.width / 2), - (object.height / 2), object.width, object.height)
	love.graphics.pop()
end

function draw_ellipse(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		function sub_ellipse(x, y, w, h)
			love.graphics.rectangle(object.filling, x, y, w, h, 
									object.width / 2, object.height / 2)
		end
		draw_subs(object, sub_ellipse)
	love.graphics.pop()
end

function draw_triangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		local w0 = object.width / 2
		local h0 = object.height / 2
		for hurt = player.curr_damage, player.max_damage do
			local s = 1 - hurt / player.max_damage
			local diff = 1.1
			vertices = {0, - h0 + diff*s*h0,
						w0 - diff*s*w0, h0 - s*h0,
						- w0 + diff*s*w0, h0 - s*h0}
			love.graphics.polygon(object.filling, vertices)
		end
	love.graphics.pop()
end

function draw_subs(object, func)
	local x0 = - (object.width / 2)
	local y0 = - (object.height / 2)
	local w0 = object.width
	local h0 = object.height
	for hurt = player.curr_damage, player.max_damage do
		local p = hurt / player.max_damage
		func(x0 + w0/2 * (1-p), y0 + h0/2 * (1-p), w0 * p, h0 * p)
	end
end
