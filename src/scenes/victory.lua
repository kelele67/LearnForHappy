local v = require"uservalues"
local s = require"scenes.base"

local oldFont, bigFont

local timeout = 3
local currentTimeout = 0
local canPass = false
local bg = nil
local Student = nil
local university = nil
local heart = nil

function s.load()
	v.currentMiniGame = "minigame"
	oldFont = love.graphics.getFont()
	bigFont = love.graphics.newFont("卷雅花蔓体.ttf", 100)
	currentTimeout = 0
	canPass = false
	bg = love.graphics.newImage("resource/image/map_bg.png")
	student = love.graphics.newImage("resource/image/student_good.png")
	university = love.graphics.newImage("resource/image/university.png")
	heart = love.graphics.newImage("resource/image/heart.png")
	love.graphics.setBackgroundColor(240, 240, 240)
end

function s.draw()
	love.graphics.draw(bg)
	love.graphics.draw(student, 800, 300, 0, -0.5, 0.5)
	love.graphics.draw(university, 950, 310, 0, -0.5, 0.5)
	love.graphics.draw(heart, 700, 170)

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0, 139, 139, 255)
	love.graphics.setFont(bigFont)
	love.graphics.printf("挑战成功", 80, 150, 400, "center")

	love.graphics.printf("尽管一路上走的很艰难，但是你还是考上了自己心仪的大学", 80, 320, 1000, "center", 0, 0.4, 0.4)

	love.graphics.setFont(oldFont)
	love.graphics.setColor(r, g, b, a)
end

function s.update(dt)
	currentTimeout = currentTimeout + dt
	if currentTimeout >= timeout then
		canPass = true
	end
end

function s.keypressed(key)
	if key == "eacape" or key == "return" then
		if canPass then
			loadScene("menu")
		end
	end
end

function s.mousepressed( ... )
	if canPass then
		loadScene("menu")
	end
end
return s