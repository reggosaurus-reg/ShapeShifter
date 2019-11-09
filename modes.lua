require("objects")

mode_see = {func_draw = function() 
				love.graphics.print("SEE", 0, 0)
				draw_ellipse(player)
				draw_shot()
				--enemy:draw()
			  end,
		  func_update = function(dt) 
			  		--move(player,dt) 
		  			rotate(player, dt)
					update(player)
					update_other_objects(dt)
				end,
		  func_shoot = function()
			  end
			}

mode_move = {func_draw = function() 
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

mode_attack = {func_draw = function() 
				   love.graphics.print("ATTACK", 0, 0)
				   draw_triangle(player) 
				   draw_shot()
			     end,
			  func_update = function(dt) 
				  		--move(player,dt) 
						rotate(player, dt)
						update(player)
						update_other_objects(dt)
					end,
			  func_shoot = function()
						shot_args = {}
						shot_args.x = player.x
						shot_args.y = player.y
						shot_args.rotation = player.rotation - math.pi / 2
						shots[#shots + 1] = spawn("shot", shot_args)
					end
			 }

function draw_shot()
	for i, shot in pairs(shots) do
		shot:draw()
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
