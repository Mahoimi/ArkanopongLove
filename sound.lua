sound = {}

local mute = true

sounds = {}

sounds.theme = love.audio.newSource("sound/music.mp3", "stream")
sounds.theme:setVolume(0.3)
sounds.game_over = love.audio.newSource("sound/game_over.wav", "stream")
sounds.kick = love.audio.newSource("sound/kick.wav", "static")

function sound.play(source)
	source:play()
end

function sound.stop(source)
	source:stop()
end

function sound.getMute()
	return mute
end

function sound.setMute(bool)
	mute = bool
	
	if mute then
		sounds.theme:setVolume(0)
		sounds.game_over:setVolume(0)
		sounds.kick:setVolume(0)
	else
		sounds.theme:setVolume(0.3)
		sounds.game_over:setVolume(1)
		sounds.kick:setVolume(1)
	end
	
end

