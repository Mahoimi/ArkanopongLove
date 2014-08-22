function love.conf(t)
	t.window.width = 400
	t.window.height = 800
	t.window.resizable = false
	t.window.title = "Arkanopong with Lua by Thomas Demenat"
	
	t.modules.joystick = false
	t.modules.mouse = false
	t.modules.physics = false
	t.modules.system = false
	t.modules.thread = false
end