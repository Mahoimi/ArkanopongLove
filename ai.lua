ai = {}

function ai.update(_stick, balls)
	_stick.right_pressed = false
	_stick.left_pressed = false
	_stick.shoot_pressed = false

	if balls[1].dy < 0 and balls[1].y < balls[2].y then
		-- Follow balls[1]
		if _stick.x + _stick.w/2 < balls[1].x then
			if _stick.invert then
				_stick.left_pressed = true
			else
				_stick.right_pressed = true
			end
		else
			if _stick.invert then
				_stick.right_pressed = true
			else
				_stick.left_pressed = true
			end
		end
	elseif balls[2].dy < 0 and balls[2].y < balls[1].y then
		-- Follow balls[2]
		if _stick.x + _stick.w/2 < balls[2].x then
			if _stick.invert then
				_stick.left_pressed = true
			else
				_stick.right_pressed = true
			end
		else
			if _stick.invert then
				_stick.right_pressed = true
			else
				_stick.left_pressed = true
			end
		end
	end
	
	if balls[1].on_stick_top or balls[2].on_stick_top then
		_stick.shoot_pressed = true
	end
end

