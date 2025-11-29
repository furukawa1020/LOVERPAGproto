local Audio = {}

Audio.sources = {}
Audio.bgm = {}
Audio.currentBGM = nil
Audio.bgmTimer = 0
Audio.bgmNote = 1

-- Simple waveforms
local function generateWave(type, duration, freq)
    local rate = 44100
    local length = math.floor(rate * duration)
    local data = love.sound.newSoundData(length, rate, 16, 1)
    
    for i = 0, length - 1 do
        local t = i / rate
        local sample = 0
        if type == "square" then
            sample = (math.sin(t * freq * 2 * math.pi) > 0) and 0.5 or -0.5
        elseif type == "noise" then
            sample = (math.random() * 2 - 1) * 0.5
        elseif type == "saw" then
            sample = ((t * freq) % 1) * 2 - 1
        end
        
        -- Envelope (Fade out)
        sample = sample * (1 - i / length)
        
        data:setSample(i, sample)
    end
    
    return love.audio.newSource(data, "static")
end

function Audio.init()
    -- SFX
    Audio.sources.select = generateWave("square", 0.1, 880)
    Audio.sources.attack = generateWave("noise", 0.2, 0)
    Audio.sources.hit = generateWave("saw", 0.3, 110)
    
    -- BGM Patterns (Note frequencies)
    Audio.bgm.field = {261, 329, 392, 523, 392, 329} -- C Major Arpeggio
    Audio.bgm.battle = {110, 110, 123, 110, 130, 110, 123, 110} -- Fast Bass
end

function Audio.playSFX(name)
    if Audio.sources[name] then
        Audio.sources[name]:clone():play()
    end
end

function Audio.playBGM(name)
    if Audio.currentBGM ~= name then
        Audio.currentBGM = name
        Audio.bgmNote = 1
        Audio.bgmTimer = 0
    end
end

function Audio.update(dt)
    if not Audio.currentBGM then return end
    
    local tempo = 0.2 -- Seconds per note
    if Audio.currentBGM == "battle" then tempo = 0.1 end
    
    Audio.bgmTimer = Audio.bgmTimer + dt
    if Audio.bgmTimer >= tempo then
        Audio.bgmTimer = Audio.bgmTimer - tempo
        
        local pattern = Audio.bgm[Audio.currentBGM]
        local freq = pattern[Audio.bgmNote]
        
        -- Play note
        local note = generateWave("square", tempo * 0.8, freq)
        note:setVolume(0.2) -- Lower volume for BGM
        note:play()
        
        Audio.bgmNote = Audio.bgmNote + 1
        if Audio.bgmNote > #pattern then Audio.bgmNote = 1 end
    end
end

return Audio
