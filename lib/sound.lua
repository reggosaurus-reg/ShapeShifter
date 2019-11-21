require("lib/slam")

sound = {}
music = {}

local sound_path = "res/sound/"

-- SOUND EFFECTS
sound.enemy_hit	  = love.audio.newSource(sound_path.."enemy_hit.wav", "static")
sound.enemy_spawn = love.audio.newSource({
		sound_path.."enemy_spawn_long.wav", 
		sound_path.."enemy_spawn_short.wav"
}, "static")
sound.player_hit  = love.audio.newSource({
		sound_path.."hit_short.wav", 
		sound_path.."hit_long.wav"
}, "static")
sound.shoot				= love.audio.newSource(sound_path.."shot.wav", "static")

-- MUSIC
music.main_music_started = false
music.bergakung    = love.audio.newSource(sound_path.."bergakung.wav", "stream")
music.penta        = love.audio.newSource(sound_path.."penta.wav", "stream")
music.western      = love.audio.newSource(sound_path.."western.wav", "stream")

music.bergakung:setLooping(true)
music.penta:setLooping(true)
music.western:setLooping(false)

