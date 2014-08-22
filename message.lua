message = {}

messageImage = {}
messageImage.replay = love.graphics.newImage("img/replay.png")
messageImage.win = love.graphics.newImage("img/gg_msg.png")
messageImage.lose = love.graphics.newImage("img/pwned_msg.png")
messageImage.invert = love.graphics.newImage("img/invert_msg.png")
messageImage.superball = love.graphics.newImage("img/superball_msg.png")
messageImage.slow = love.graphics.newImage("img/speeddown_msg.png")

local message_time_max = 4

function message.newMessage(owner, img)
	local message = {}
	message.img = img
	message.elapsed = 0
	
	message.x = window_width / 2 - message.img:getWidth() / 2
	
	if owner == 2 then
		message.y = window_height / 4 - message.img:getHeight() / 2
	else
		message.y = 3 * window_height / 4 - message.img:getHeight() / 2
	end
	
	table.insert(messages, message)
end

function message.hasExpired(_message, dt)
	_message.elapsed = _message.elapsed + dt
	
	if _message.elapsed > message_time_max then
		return true
	end
	
	return false
end