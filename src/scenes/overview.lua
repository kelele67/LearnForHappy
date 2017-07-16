require"rect"
require"playerbar"

local s = require"scenes.base"
local v = require"uservalues"

s.bgImage = nil
s.pathImage = nil
s.animTime = 0
s.displayHistory = false

s.historyPages = {
	["minigame"] = "resource/image/scene_bg.png",
}

s.stageLocations = {
	minigame = 0,
	minigame2 = 220,
	minigame3 = 260,
	minigame4 = 900,
}

s.pathQuad = nil

function s.load()
	--检查当前的状态和相应的图像进行小游戏
	s.bgImage = love.graphics.newImage("resource/image/map.png")
	s.pathImage = love.graphics.newImage("resource/image/path.png")
	s.pathQuad = love.graphics.newQuad(0, 0, s.stageLocations[v.currentMiniGame], s.pathImage:getHeight(), s.pathImage:getWidth(), s.pathImage:getHeight())
	if s.historyPages[v.currentMiniGame] then
		s.historyImage = love.graphics.newImage(s.historyPages[v.currentMiniGame])
	else 
		s.historyImage = nil
	end

	s.loadButtons()

	love.graphics.setBackgroundColor(240, 240, 240)

end

local function drawButton(x, y, w, h, text)
	local r, g, b, a = love.graphics.getColor()
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(finishedFont)

	love.graphics.setColor(255, 255, 255, 200)
	love.graphics.rectangle("fill", x, y, w, h)

	love.graphics.setColor(210, 180, 140, a * 0.8)
	love.graphics.rectangle("fill", x + 10, y + 10, w - 20, h - 20)

	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("line", x, y, w, h)
	love.graphics.rectangle("line", x + 10, y + 10, w - 20, h - 20)

	love.graphics.setColor(0, 139, 139, 200)
	love.graphics.printf(text, x, y + 15, w, "center", 0, 1, 1)
	love.graphics.setFont(oldFont)

	love.graphics.setColor(r, g, b, a)
end

function s.loadButtons()
	if (not s.buttonLoaded) or v.reloadGame then
		local x = #v.powerButtons
		while x > 0 do
			table.remove(v.powerButtons)
			x = x - 1
		end

		-- Load the power buttons
		table.insert(v.powerButtons, Rect(50, 602, 96, 96))
		table.insert(v.powerButtons, Rect(250, 602, 96, 96))
		table.insert(v.powerButtons, Rect(450, 602, 96, 96))
		table.insert(v.powerButtons, Rect(650, 602, 96, 96))
		table.insert(v.powerButtons, Rect(850, 602, 96, 96))

		v.powerButtons[1].image = love.graphics.newImage("resource/image/sleep.png")
		v.powerButtons[1].altimage = love.graphics.newImage("resource/image/sleep2.png")
		v.powerButtons[1].name = "睡觉"
		v.powerButtons[1].qty = 10
		v.powerButtons[1].powerup = 0
		v.powerButtons[1].hpup = 10

		v.powerButtons[2].image = love.graphics.newImage("resource/image/friend.png")
		v.powerButtons[2].altimage = love.graphics.newImage("resource/image/friend2.png")
		v.powerButtons[2].name = "朋友"
		v.powerButtons[2].qty = 8
		v.powerButtons[2].powerup = 2
		v.powerButtons[2].hpup = -2

		v.powerButtons[3].image = love.graphics.newImage("resource/image/study.png")
		v.powerButtons[3].altimage = love.graphics.newImage("resource/image/study2.png")
		v.powerButtons[3].name = "看书"
		v.powerButtons[3].qty = 8
		v.powerButtons[3].powerup = 10
		v.powerButtons[3].hpup = -15

		v.powerButtons[4].image = love.graphics.newImage("resource/image/sport.png")
		v.powerButtons[4].altimage = love.graphics.newImage("resource/image/sport2.png")
		v.powerButtons[4].name = "运动"
		v.powerButtons[4].qty = 8
		v.powerButtons[4].powerup = 0
		v.powerButtons[4].hpup = 5

		v.powerButtons[5].image = love.graphics.newImage("resource/image/mistake.png")
		v.powerButtons[5].altimage = love.graphics.newImage("resource/image/mistake2.png")
		v.powerButtons[5].name = "犯错"
		v.powerButtons[5].qty = 9
		v.powerButtons[5].powerup = 5
		v.powerButtons[5].hpup = -15


		v.resetButton = Rect(840, 410, 148, 74)
		v.resetButton.draw = function(self)
			drawButton(self.x, self.y, self.w, self.h, "重置")
		end

		v.playButton = Rect(840, 500, 148, 74)
		v.playButton.draw = function(self)
			drawButton(self.x, self.y, self.w, self.h, "开始")
		end
		v.starImage = love.graphics.newImage("resource/image/star.png")

		v.currentHP = 100
		v.currentPower = 0

		v.currentMiniGame = "minigame"

		s.buttonLoaded = true
		v.reloadGame = false

	end
end


function s.update(dt)
    s.animTime = s.animTime + dt;
    if s.animTime > 2  then
    	s.displayHistory = true
    end
end

function s.draw()
    love.graphics.draw( s.bgImage, 0, 0, 0, 1, 1, 0, 0, 0, 0 )
    love.graphics.draw( s.pathImage, s.pathQuad, 290, 265 )
    if s.displayHistory and s.historyImage then
        love.graphics.draw( s.historyImage, 102, 76, 0, 0.8, 0.8, 0, 0, 0, 0 )  
    end
end

function s.mousepressed(x, y, button)
	if s.displayHistory then
		loadScene(v.currentMiniGame)
	end
end


function s.keypressed(key, isrepeat)
    if key == "return" then
    	-- Implementar a logica para descobrir qual sera a proxima cena.
        loadScene(v.currentMiniGame)
    end
    if key == "escape" then
        love.event.quit()
    end
end

return s