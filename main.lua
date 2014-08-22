require "stick"
require "ball"
require "sound"
require "message"
require "brick"
require "ai"

local background
local background_menu
local keys
local balls
local game_end = false
local winner
local menu
local players

function love.load()
	-- Backgrounds
	background = love.graphics.newImage("img/background.jpg")
	background_menu = love.graphics.newImage("img/menu.png")
	
	-- Messages
	messages = {}
	
	-- Window options
	window_width = background:getWidth()
	window_height = background:getHeight()
	
	-- Sticks
	sticks = {}
	sticks[1] = stick.newStick("img/stick_bottom.jpg")
	stick.replace(sticks[1], "bottom")
	
	sticks[2] = stick.newStick("img/stick_top.jpg")
	stick.replace(sticks[2], "top")
	
	bricks = brick.createBrickSet()
	
	-- Lifes
	life = {}
	life.bottom = love.graphics.newImage("img/lifej1.png")
	life.top = love.graphics.newImage("img/lifej2.png")
	life.w = life.bottom:getWidth()
	life.h = life.bottom:getHeight()
	
	-- Ball params
	balls = {}
	balls[1] = ball.newBall(0, 0, 1)
	balls[1].on_stick_bottom = true
	
	balls[2] = ball.newBall(0, 0, 2)
	balls[2].on_stick_top = true
	
	-- Keys
	keys = {}
	keys.one_player = '1'
	keys.two_players = '2'
	keys.j1_left = 'left'
	keys.j1_right = 'right'
	keys.j1_shoot = 'up'
	keys.j2_left = 'a'
	keys.j2_right = 'z'
	keys.j2_shoot = 'e'
	keys.mute = 'm'
	keys.replay = 'r'
	
	menu = true
end

function love.keypressed(key)
	if key == keys.j1_left then
		sticks[1].left_pressed = true
	elseif key == keys.j1_right then
		sticks[1].right_pressed = true
	elseif key == keys.j1_shoot then
		sticks[1].shoot_pressed = true
	elseif key == keys.j2_left then
		if players == 2 then
			sticks[2].left_pressed = true
		end
	elseif key == keys.j2_right then
		if players == 2 then
			sticks[2].right_pressed = true
		end
	elseif key == keys.j2_shoot then
		if players == 2 then
			sticks[2].shoot_pressed = true
		end
	elseif key == keys.one_player then
		players = 1
		startGame()
	elseif key == keys.two_players then
		players = 2
		startGame()
	elseif key == keys.mute then
		sound.setMute(not sound.getMute())
	elseif key == keys.replay then
		if game_end then
			replay()
		end
	end
end

function love.keyreleased(key)
	if key == keys.j1_left then
		sticks[1].left_pressed = false
	elseif key == keys.j1_right then
		sticks[1].right_pressed = false
	elseif key == keys.j1_shoot then
		sticks[1].shoot_pressed = false
	elseif key == keys.j2_left then
		if players == 2 then
			sticks[2].left_pressed = false
		end
	elseif key == keys.j2_right then
		if players == 2 then
			sticks[2].right_pressed = false
		end
	elseif key == keys.j2_shoot then
		if players == 2 then
			sticks[2].shoot_pressed = false
		end
	end
end

function startGame()
	if(menu)then
		sound.play(sounds.theme)
		menu = false
	end
end

function replay()
	menu = true
	game_end = false
	
	-- Stop end music
	sound.stop(sounds.game_over)
	
	-- Reset sticks
	for i, _stick in ipairs (sticks) do
		table.remove(sticks, i)
	end
	
	sticks[1] = stick.newStick("img/stick_bottom.jpg")
	stick.replace(sticks[1], "bottom")
	
	sticks[2] = stick.newStick("img/stick_top.jpg")
	stick.replace(sticks[2], "top")
	
	for i,v in ipairs(bricks) do
		table.remove(bricks, i)
	end
	
	bricks = brick.createBrickSet()
	
	for i, v in ipairs(balls) do
		table.remove(balls, i)
	end
	
	balls[1] = ball.newBall(0, 0, 1)
	balls[1].on_stick_bottom = true
	
	balls[2] = ball.newBall(0, 0, 2)
	balls[2].on_stick_top = true
	
end

function love.update(dt)
	if(not menu and not game_end) then
	
		-- If a player has no life left
		for i, _stick in ipairs(sticks) do
			if(_stick.life == 0) then
				game_end = true
				winner = i % 2 + 1
				
				for i,v in ipairs(messages) do
					table.remove(messages, i)
				end
				
				sound.stop(sounds.theme)
				sound.play(sounds.game_over)
				
			end
		end
		
		if players == 1 then
			ai.update(sticks[2], balls)
		end
	
		-- Update sticks positions
		for i, _stick in ipairs(sticks) do
			stick.update(_stick, dt)
		end
		
		-- Update ball position
		for i, _ball in ipairs(balls) do
			ball.animate(_ball, dt)
			ball.update(_ball, dt)
		end
		
		-- Update messages
		for i, _message in ipairs(messages) do
			if message.hasExpired(_message, dt) then
				table.remove(messages, i)
			end
		end
	end
end

function love.draw()
	if(not menu)then
		love.graphics.draw(background, 0, 0)
		
		-- Draw sticks
		love.graphics.draw(sticks[1].img, sticks[1].x, sticks[1].y)
		love.graphics.draw(sticks[2].img, sticks[2].x, sticks[2].y)
		
		-- Draw bricks
		for i, _brick in ipairs(bricks) do
			love.graphics.draw(_brick.img, _brick.x, _brick.y)
		end
		
		-- Draw Lifes
		for i = 0, sticks[2].life - 1 do
			love.graphics.draw(life.top, i*window_width/10, 0)
		end
		
		for i = 0, sticks[1].life - 1 do
			love.graphics.draw(life.bottom, i*window_width/10, window_height - life.h)
		end
		
		-- Draw balls
		for i, _ball in ipairs(balls) do
			love.graphics.draw(_ball.img, _ball.x, _ball.y)
		end
		
		-- Draw messages
		for i, _message in ipairs(messages) do
			love.graphics.draw(_message.img, _message.x, _message.y)
		end
		
		if(game_end) then
			-- Replay message
			local message_x = window_width/2 - messageImage.replay:getWidth()/2
			
			love.graphics.draw(messageImage.replay, message_x, window_height/2 - messageImage.replay:getHeight()/2 )
			
			-- Winner message
			message_x = window_width/2 - messageImage.win:getWidth()/2
			local winner_y
			local loser_y
			if winner == 2 then
				winner_y = window_height / 4 - messageImage.win:getHeight() / 2
				loser_y = 3 * window_height / 4 - messageImage.lose:getHeight() / 2
			else
				loser_y = window_height / 4 - messageImage.lose:getHeight() / 2
				winner_y = 3 * window_height / 4 - messageImage.win:getHeight() / 2
			end
			
			love.graphics.draw(messageImage.win, message_x, winner_y )
			love.graphics.draw(messageImage.lose, message_x, loser_y )

		end
	else
		love.graphics.draw(background_menu, 0, 0)
	end
end