require("objects")

see = {draw = function() 
				love.graphics.print("SEE", 0, 0)
				draw_ellipse(player)
				enemy:draw()
			  end}

move = {draw = function() 
				 love.graphics.print("MOVE", 0, 0)
				 draw_rectangle(player) 
			   end}

attack = {draw = function() 
				   love.graphics.print("ATTACK", 0, 0)
				   draw_triangle(player) 
			     end}


