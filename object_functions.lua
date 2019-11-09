-- Draw functions

function draw_rectangle(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		love.graphics.rectangle("line", - (object.width / 2), - (object.height / 2), 
				object.width, object.height,
				(object.width / 2) * object.round,
				(object.height / 2) * object.round
		)
	love.graphics.pop()
end

-- Update functions

function move(object, dt)
	object.rotation = object.rotation + object.rotation_dir * rotation_speed * dt
	
	-- if object.canMove()
	object.x = object.x + object.x_dir * object.x_speed * dt
	object.y = object.y + object.y_dir * object.y_speed * dt
end

function update(object)

end
