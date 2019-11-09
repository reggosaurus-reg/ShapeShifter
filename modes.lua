require("objects")

mode_see = {func_draw = function() 
				love.graphics.print("SEE", 0, 0)
				draw_ellipse(player)
				--enemy:draw()
			  end,
		  func_update = function(dt) 
			  move(player,dt) 
		  			rotate(player, dt)
					update(player)
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
					end
		   }

mode_attack = {func_draw = function() 
				   love.graphics.print("ATTACK", 0, 0)
				   draw_triangle(player) 
			     end,
			  func_update = function(dt) 
				  move(player,dt) 
						rotate(player, dt)
						update(player)
					end
			 }


