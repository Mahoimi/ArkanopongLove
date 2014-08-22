require "physics"
require "sound"
require "brick"

local superball_time_max = 5
local animation_time = 0.1

ball = {}

ballType = {}
ballType.bottom = 1
ballType.top = 5
ballType.superball = 9

ballImage = {}
ballImage[1] = love.graphics.newImage("img/ball_j1_1.png")
ballImage[2] = love.graphics.newImage("img/ball_j1_2.png")
ballImage[3] = love.graphics.newImage("img/ball_j1_3.png")
ballImage[4] = love.graphics.newImage("img/ball_j1_4.png")

ballImage[5] = love.graphics.newImage("img/ball_j2_1.png")
ballImage[6] = love.graphics.newImage("img/ball_j2_2.png")
ballImage[7] = love.graphics.newImage("img/ball_j2_3.png")
ballImage[8] = love.graphics.newImage("img/ball_j2_4.png")

ballImage[9] = ballImage[1]
ballImage[10] = ballImage[5]
ballImage[11] = love.graphics.newImage("img/superball_j1_3.png")
ballImage[12] = love.graphics.newImage("img/superball_j2_4.png")

function ball.newBall(x, y, owner)
	local ball = {}
	ball.dx = 220
	ball.dy = 160
	ball.owner = owner
	ball.type = owner * 4 - 3
	ball.img = ballImage[ball.type]
	ball.w = ball.img:getWidth()
	ball.h = ball.img:getHeight()
	ball.x = x
	ball.y = y
	ball.on_stick_top = false
	ball.on_stick_bottom = false
	ball.superball = false
	ball.on_stick_elapsed = 0
	ball.animation_elapsed = 0
	ball.super_time = 0
	
	return ball
end

function ball.animate(_ball, dt)
	if(not _ball.on_stick_top and not _ball.on_stick_bottom)then
		_ball.animation_elapsed = _ball.animation_elapsed + dt
		
		if(_ball.animation_elapsed > animation_time)then
			local newType = _ball.type + 1
			if(newType == 5 or newType == 9 or newType == 13) then
				newType = newType - 4
			end
			_ball.type = newType
			_ball.img = ballImage[newType]
			_ball.animation_elapsed = 0
		end
	end
end

function ball.update(_ball, dt)
	-- Shoot ball from stick
	if _ball.on_stick_top then
		_ball.on_stick_elapsed = _ball.on_stick_elapsed + dt
		if sticks[2].shoot_pressed and _ball.on_stick_elapsed > 1 then
			_ball.on_stick_top = false
			_ball.on_stick_elapsed = 0
			sticks[2].shoot_pressed = false
		end
	end
	
	if _ball.on_stick_bottom then
		_ball.on_stick_elapsed = _ball.on_stick_elapsed + dt
		if sticks[1].shoot_pressed and _ball.on_stick_elapsed > 1 then
			_ball.on_stick_bottom = false
			_ball.on_stick_elapsed = 0
			sticks[1].shoot_pressed = false
		end
	end

	-- General movement
	if not _ball.on_stick_top and not _ball.on_stick_bottom then
		_ball.x = _ball.x + _ball.dx * dt
		_ball.y = _ball.y + _ball.dy * dt
	end
	
	-- Follow the stick position
	if _ball.on_stick_top then
		_ball.x = sticks[2].x + sticks[2].w / 2 - _ball.w / 2
		_ball.y = sticks[2].y + sticks[2].h
	end
	
	if _ball.on_stick_bottom then
		_ball.x = sticks[1].x + sticks[1].w / 2 - _ball.w / 2
		_ball.y = sticks[1].y - _ball.h
	end
	
	local collision = false
	
	-- Ball colisions with walls
	if physics.collision_wall(_ball) then
		_ball.dx = _ball.dx * -1
		collision = true
	end
	
	-- Ball collisions with sticks
	if physics.collision(_ball, sticks[1])  then
		collision = true
		_ball.owner = 1
		if not _ball.superball then
			_ball.type = ballType.bottom
			_ball.img = ballImage[ballType.bottom]
		end
	elseif physics.collision(_ball, sticks[2])  then
		collision = true
		_ball.owner = 2
		if not _ball.superball then
			_ball.type = ballType.top
			_ball.img = ballImage[ballType.top]
		end
	end
	
	-- Ball collisions with bricks
	local prev_dx = _ball.dx
	local prev_dy = _ball.dy
	for i, _brick in ipairs(bricks) do
		if physics.collision(_ball, _brick)  then
			if _ball.superball then
				_ball.dx = prev_dx
				_ball.dy = prev_dy
			end
			brick.collision(_brick, _ball)
			collision = true
			break
		end
	end
	
	-- Sound collision
	if collision and not _ball.on_stick_top and not _ball.on_stick_bottom then
		sound.play(sounds.kick)
	end
	
	-- Superball elapsed time
	if _ball.superball then
		_ball.super_time = _ball.super_time + dt
		if _ball.super_time > superball_time_max then
			_ball.superball = false
			_ball.type = _ball.owner * 4 - 3
			_ball.img = ballImage[_ball.type]
		end
	end
	
	-- If ball is off-screen, the player lose a life
	if _ball.y + _ball.w < 0 then
		sticks[2].life = sticks[2].life - 1
		_ball.dy = _ball.dy * -1
		_ball.superball = false
		_ball.on_stick_top = true
	elseif _ball.y - _ball.w > window_height then
		sticks[1].life = sticks[1].life - 1
		_ball.dy = _ball.dy * -1
		_ball.superball = false
		_ball.on_stick_bottom = true
	end
end