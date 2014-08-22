physics = {}

function physics.collision_wall(_rectangle)
	if(_rectangle.x < 0) then 
		_rectangle.x = 0
		return true
	elseif (_rectangle.x + _rectangle.w > window_width) then 
		_rectangle.x = window_width - _rectangle.w
		return true
	end
	return false
end

function physics.collision(_ball, _rectangle)
	if(_ball.x + _ball.w < _rectangle.x 
	or _rectangle.x + _rectangle.w < _ball.x 
	or _ball.y + _ball.h < _rectangle.y 
	or _rectangle.y + _rectangle.h < _ball.y) then
		return false
	end
	
	local x11 = _ball.x
	local y11 = _ball.y
	local x12 = _ball.x + _ball.w
	local y12 = _ball.y + _ball.h
	local x21 = _rectangle.x
	local y21 = _rectangle.y
	local x22 = _rectangle.x + _rectangle.w
	local y22 = _rectangle.y + _rectangle.h
	
	local overlap_x = math.max(0, math.min(x12, x22) - math.max(x11, x21))
	local overlap_y = math.max(0, math.min(y12,y22) - math.max(y11,y21))
	
	if(overlap_x >= overlap_y) then
		if((_ball.y > _rectangle.y and _ball.dy < 0) or (_ball.y < _rectangle.y and _ball.dy > 0)) then
			_ball.dy = _ball.dy *-1
		end
	else
		if((_ball.x > _rectangle.x and _ball.dx < 0) or (_ball.x < _rectangle.x and _ball.dx > 0)) then
			_ball.dx = _ball.dx *-1
		end
	end
	
	return true
end