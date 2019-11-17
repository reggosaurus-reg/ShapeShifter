require("lib/slam")

-- KEYMAP
alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"

yf_font = "res/yf16font.ttf"
big_font = love.graphics.newFont(yf_font, 55)
medium_font = love.graphics.newFont(yf_font, 35)
small_font = love.graphics.newFont(yf_font, 15)
small_font:setFilter( "nearest", "nearest" )
medium_font:setFilter( "nearest", "nearest" )
big_font:setFilter( "nearest", "nearest" )

key_right = "right"
key_left = "left"
key_up = "up"
key_down = "down"
key_see = "1"
key_move = "2"
key_attack = "3"
-- "none", "rot", "move"
pressed_keys = {left = "none", right = "none", up = "none", down = "none"}

rotation_speed = math.pi * 2  -- half a lap per second

win_w = 800	
win_h = 600

hs_holder = "A. Nonymous"
highscore = 0
max_damage = 4

enemy_spawn_interval = 2
enemies_spawned = 0

shot_interval = 1

function reset_state_values()
	-- reset all state-values (that change every game)
	enemies_spawned = 0
	last_shot = 0
end

function reset_all_values()
	-- reset ALL values (including save-data)
end

-- SOUND EFFECTS
sound_path = "res/sound/"
sound_enemy_hit	  = love.audio.newSource(sound_path.."enemy_hit.wav", "static")
sound_enemy_spawn = love.audio.newSource({
		sound_path.."enemy_spawn_long.wav", 
		sound_path.."enemy_spawn_short.wav"
}, "static")
sound_player_hit  = love.audio.newSource({
		sound_path.."hit_short.wav", 
		sound_path.."hit_long.wav"
}, "static")
sound_shoot				= love.audio.newSource(sound_path.."shot.wav", "static")

-- MUSIC
main_music_started = false
music_western      = love.audio.newSource(sound_path.."western.wav", "stream")
music_bergakung    = love.audio.newSource(sound_path.."bergakung.wav", "stream")
music_penta        = love.audio.newSource(sound_path.."penta.wav", "stream")
