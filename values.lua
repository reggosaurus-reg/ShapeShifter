require("slam")

-- KEYMAP
rot_l = "j"
rot_r = "k"
inc_x = "d"
dec_x = "a"
inc_y = "w"
dec_y = "s"
key_see = "1"
key_move = "2"
key_attack = "3"

win_w = 800	
win_h = 600

hs_holder = "A. Nonymous"
highscore = 0
max_damage = 4

-- SOUND EFFECTS
sound_enemy_hit	  = love.audio.newSource("sound/enemy_hit.wav", "static")
sound_enemy_spawn = love.audio.newSource({
		"sound/enemy_spawn_long.wav", 
		"sound/enemy_spawn_short.wav"
}, "static")
sound_player_hit  = love.audio.newSource({
		"sound/hit_short.wav", 
		"sound/hit_long.wav"
}, "static")
sound_shoot				= love.audio.newSource("sound/shot.wav", "static")

-- MUSIC
music_western   = love.audio.newSource("sound/western.wav", "stream")
music_bergakung = love.audio.newSource("sound/bergakung.wav", "stream")
music_penta     = love.audio.newSource("sound/penta.wav", "stream")
