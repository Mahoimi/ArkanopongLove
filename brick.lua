require "message"

brick = {}

brickType = {}
brickType.normal = 0
brickType.resist = 1
brickType.unbreakable = 4
brickType.invert = 5
brickType.widden = 6
brickType.slow = 7
brickType.superball = 8

brickImage = {}
brickImage[0] = love.graphics.newImage("img/brick_classic.jpg")
brickImage[1] = love.graphics.newImage("img/brick_step0.jpg")
brickImage[2] = love.graphics.newImage("img/brick_step1.jpg")
brickImage[3] = love.graphics.newImage("img/brick_step2.jpg")
brickImage[4] = love.graphics.newImage("img/brick_unbreakable.jpg")
brickImage[5] = love.graphics.newImage("img/brick_bonus1.jpg")
brickImage[6] = love.graphics.newImage("img/brick_bonus2.jpg")
brickImage[7] = love.graphics.newImage("img/brick_bonus3.jpg")
brickImage[8] = love.graphics.newImage("img/brick_bonus4.jpg")

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function brick.createBrickSet()
	local brickSet = {
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{4, 4, 5, 7, 8, 8, 7, 5, 4, 4},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	}
	
	local brick_width = brickImage[0]:getWidth()
	local brick_height = brickImage[0]:getHeight()
	
	
	local bricks = {}
	
	local tab_height = tablelength(brickSet)
	for j=1, tab_height do
		local tab_width = tablelength(brickSet[j])
		for i=1, tab_width  do
			local x = (-(tab_width)*brick_width)/2 + (i-1)*brick_width + window_width/2
			local y = (-(tab_height)*brick_height)/2 + (j-1)*brick_height + window_height/2
			table.insert(bricks, brick.newBrick(x, y, brickSet[j][i]))
		end
	end
	
	return bricks
end

function brick.newBrick(x, y, brick_type)
	local brick = {}
	brick.x = x
	brick.y = y
	brick.type = brick_type
	brick.img = brickImage[brick_type]
	brick.w = brick.img:getWidth()
	brick.h = brick.img:getHeight()
	
	return brick
end

function brick.collision(_brick, _ball)
	if not _ball.superball then
		if(_brick.type == brickType.unbreakable) then
			return
		elseif(_brick.type >= brickType.resist and _brick.type < brickType.resist + 3 ) then
			_brick.type = _brick.type + 1
			if(_brick.type < brickType.resist + 3) then
				_brick.img = brickImage[_brick.type]
				return
			end
		elseif(_brick.type == brickType.invert) then
			local target = (_ball.owner % 2 ) + 1
			sticks[target].invert = not sticks[target].invert
			
			message.newMessage(target, messageImage.invert)
		--[[elseif(_brick.type == brickType.widden) then]]--
		elseif(_brick.type == brickType.slow) then
			local target = (_ball.owner % 2 ) + 1
			sticks[target].speed = 150
			
			message.newMessage(target, messageImage.slow)
		elseif(_brick.type == brickType.superball) then
			_ball.superball = true
			_ball.super_time = 0
			_ball.type = ballType.superball
			_ball.img = ballImage[ballType.superball]
			
			message.newMessage(_ball.owner, messageImage.superball)
		end
	end
	
	for i,v in ipairs(bricks) do
		if(v == _brick)then
			table.remove(bricks, i)
			break
		end
	end
	
end