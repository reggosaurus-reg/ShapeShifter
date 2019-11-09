require("objects")

see = {draw = function() 
				love.graphics.print("SEE", 0, 0)
				player:draw()
				enemy:draw()
			  end}

move = {draw = function() 
				 love.graphics.print("MOVE", 0, 0)
				 player:draw() 
			   end}

attack = {draw = function() 
				   love.graphics.print("ATTACK", 0, 0)
				   player:draw() 
			     end}


