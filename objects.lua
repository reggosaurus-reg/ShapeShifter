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

function draw_ellipse(object)
	love.graphics.push()
		love.graphics.translate(object.x, object.y)
		love.graphics.rotate(object.rotation)
		love.graphics.rectangle("line", - (object.width / 2), - (object.height / 2), 
				object.width, object.height,
				(object.width / 2),
				(object.height / 2)
		)
	love.graphics.pop()
end

function draw_triangle(object)
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
-- TODO: Enforce that object has x, y, speed, dir, height, width, round, rotation...

-- Player data
player = {}
player.x = win_w / 2
player.y = win_h / 2
player.x_speed = 300
player.y_speed = 300
player.x_dir = 0
player.y_dir = 0
player.height = 120
player.width = 80
player.rotation = 0  -- radians
player.rotation_dir = 0
player.round = 0  -- andel: 0 = kvadrat, 1 = cirkel/ellips

-- Player functions
--player.draw = draw_rectangle
player.move = move
player.update = update

-- Enemy data
enemy = {}
enemy.x = 0	 
enemy.y = 0 
enemy.x_speed = 100
enemy.y_speed = 100
enemy.x_dir = 1
enemy.y_dir = 1
enemy.height = 80 
enemy.width = 80
enemy.rotation = 0  
enemy.rotation_dir = 0
enemy.round = 1 

-- Enemy functions
enemy.draw = draw_rectangle
enemy.move = move
enemy.update = update
