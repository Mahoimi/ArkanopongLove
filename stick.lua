require "physics"

stick = {}

function stick.newStick(imagepath)
	local stick = {}
	stick.img = love.graphics.newImage(imagepath)
	stick.w = stick.img:getWidth()
	stick.h = stick.img:getHeight()
	stick.x = 0
	stick.y = 0
	stick.speed = 200
	stick.life = 10
	stick.left_pressed = false
	stick.right_pressed = false
	stick.shoot_pressed = false
	stick.invert = false
	
	return stick
end

function stick.replace(_stick, position)
	_stick.x = window_width / 2 - _stick.w / 2
	
	if(position == "bottom")then
		_stick.y = 96 * window_height / 100 - _stick.h / 2
	elseif(position == "top")then
		_stick.y = 4 * window_height / 100 - _stick.h / 2
	end
end

function stick.update(_stick, dt)
	if((_stick.left_pressed and not _stick.invert)
	 or(_stick.right_pressed and _stick.invert)) then
		_stick.x = _stick.x - _stick.speed * dt
	elseif((_stick.right_pressed and not _stick.invert)
		or(_stick.left_pressed and _stick.invert)) then
		_stick.x = _stick.x + _stick.speed * dt
	end
	
	-- Prevent sticks to go out of the window
	physics.collision_wall(_stick)
end

