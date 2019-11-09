require("object_functions")

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
player.draw = draw_rectangle
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
