require "rect"

local s = require"scenes.base"
local v = require"uservalues"
local oldFont, buttonFont, bigFont
local bg, university, student

s.soundtrack = nil

function s.load()
	oldFont = love.graphics.getFont()
	buttonFont = love.graphics.newFont("卷雅花蔓体.ttf", 50)
	bigFont = love.graphics.newFont("卷雅花蔓体.ttf", 120)
	creditsFont = love.graphics.newFont("卷雅花蔓体.ttf", 24)

	startButton = Rect(love.graphics.getWidth() / 2 - 70, 400, 140, 50)
	startButton.text = "开始"

	exitButton = Rect(love.graphics.getWidth() / 2 - 50, 550, 100, 50)
	exitButton.text = "退出"

	bg = love.graphics.newImage("resource/image/map_bg.png")
	university = love.graphics.newImage("resource/image/university.png")
	student = love.graphics.newImage("/resource/image/student.png")
	love.graphics.setBackgroundColor(240, 240, 240)

	s.soundtrack = love.audio.newSource("resource/audio/menu.mp3")
	s.soundtrack:setLooping(true)
	s.soundtrack:play()

	v.reloadGame = true

end

function s.unload()
	love.graphics.setFont(oldFont)
	buttonFont = nil
	bigFont = nil
end

function s.mousepressed(x, y, k)
	if startButton:isInside(x, y) then
		v.reloadGame = true
		loadScene("guide")
	end
	if exitButton:isInside(x, y) then
		love.event.quit()
	end
end

function s.update(dt)
end

function s.draw()
	love.graphics.draw(bg)
	love.graphics.draw(university, love.graphics.getWidth() - 120, 260, 0, -0.6, 0.6)
	love.graphics.draw(student, student:getWidth() * 0.6 + 60, 220, 0, -0.6, 0.6)

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setFont(bigFont)
	love.graphics.setColor(153, 110, 93, 255)
	love.graphics.printf("Learn", 0, 130, love.graphics.getWidth() / 2 - 80, "right")
	love.graphics.setColor(255, 255, 255, 193)
	love.graphics.printf("for", 0, 130, love.graphics.getWidth(), "center")
	love.graphics.setColor(93, 128, 125, 255)
	love.graphics.printf("Happy", love.graphics.getWidth() / 2 + 80, 130, love.graphics.getWidth(), "left")

	love.graphics.setFont(buttonFont)
	love.graphics.printf(startButton.text, startButton.x, startButton.y, startButton.w, "center")
	love.graphics.printf(exitButton.text, exitButton.x, exitButton.y, exitButton.w, "center")

	love.graphics.setFont(creditsFont)
	love.graphics.setColor(93, 128, 125, 255)
	love.graphics.printf("Good Good Study, Day Day Up ", 0, love.graphics.getHeight() - 40, love.graphics.getWidth(), "center")

	love.graphics.setColor(r, b, g, a)
	love.graphics.setFont(oldFont)

	startButton:draw()
	exitButton:draw()

end

function s.keypressed(key, isrepeat)
	if key == "escape" then
		love.event.quit()
	end
end
return s

