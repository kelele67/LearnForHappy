local v = require"uservalues"
local s = require"scenes.base"

local oldFont, bigFont

local timeout = 3
local currentTimeout = 0
local canPass = false
local bg = nil
local flag = nil

function s.load()
	v.currentMiniGame = "minigame"
	oldFont = love.graphics.getFont()
	bigFont = love.graphics.newFont("卷雅花蔓体.ttf", 120)
	currentTimeout = 0
	canPass = false
	bg = love.graphics.newImage("resource/image/map_bg.png")
  student = love.graphics.newImage("resource/image/student_ill.png")
	flag = love.graphics.newImage("resource/image/flag.png")
	love.graphics.setBackgroundColor(240, 240, 240)

end

function s.draw()
	love.graphics.draw(bg)
  love.graphics.draw(student, 900, 300, 0, -0.5, 0.5)
	love.graphics.draw(flag, 570, 220, 0, 0.2, 0.2)

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0, 139, 139, 255)
	love.graphics.setFont(bigFont)
	love.graphics.printf("游戏\n结束", 80, 150, 400, "center")

	love.graphics.printf("可惜了 最终还是没能实现自己的心愿 再见了高中", 80, 450, 1000, "center", 0, 0.4, 0.4)

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
	if key == "escape" or key == "return" then
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