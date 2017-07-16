require"rect"
require"playerbar"
require"student"

local uservalues = require"uservalues"
local s = require"scenes.base"

s.sensibleAreas = {}
s.curPower = nil

s.bar = nil
-- s.university = nil
s.student = nil
s.bg = nil

s.playing = false
s.animframe = 0
s.gamefinished = false
--s.gameover = false

--check star bonus
s.starTrashold = 25
s.starEarned = false
s.deltaPower = 0
s.deltaHp = 0

function s.load()
	table.insert(s.sensibleAreas, Rect(30, 350, 96, 96))
	table.insert(s.sensibleAreas, Rect(126, 350, 96, 96))
	table.insert(s.sensibleAreas, Rect(222, 350, 96, 96))
	table.insert(s.sensibleAreas, Rect(318, 350, 96, 96))
	table.insert(s.sensibleAreas, Rect(318, 254, 96, 96))
	table.insert(s.sensibleAreas, Rect(222, 254, 96, 96))
	table.insert(s.sensibleAreas, Rect(222, 158, 96, 96))
	table.insert(s.sensibleAreas, Rect(318, 158, 96, 96))
	table.insert(s.sensibleAreas, Rect(414, 158, 96, 96))

	table.insert(s.sensibleAreas, Rect(414, 254, 96, 96))
	table.insert(s.sensibleAreas, Rect(414, 350, 96, 96))
	table.insert(s.sensibleAreas, Rect(510, 350, 96, 96))
	table.insert(s.sensibleAreas, Rect(606, 350, 96, 96))
	table.insert(s.sensibleAreas, Rect(606, 254, 96, 96))
	table.insert(s.sensibleAreas, Rect(702, 254, 96, 96))

	s.bar = PlayerBar(5, 5)
	s.bar:setHealth(uservalues.currentHP)
	s.bar:setPower(uservalues.currentPower)

	s.university = love.graphics.newImage("resource/image/university.png")
	s.student = Student(s.sensibleAreas[1])

	s.bg = love.graphics.newImage("resource/image/stage4.png")

	love.graphics.setBackgroundColor(238, 231, 205)

end

function s.unload()
	if s.sensibleAreas then
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		table.remove(s.sensibleAreas)
		s.sensibleAreas = nil
	end
	s.bar = nil

	s.university = nil
end

deltaTime = 0.5;

function s.update(dt)
	if s.playing then
		deltaTime = deltaTime - dt

		if deltaTime < 0 then
			deltaTime = 0.5;
			s.animframe = s.animframe + 1;

			if (s.animframe > #s.sensibleAreas) then
				s.playing = false

				--show how much up/power was gain/lose
				s.gamefinished = true

				--goto next minigame
				uservalues.currentMiniGame = "minigame4"

			else
				if s.sensibleAreas[s.animframe].powerIdx then
					deltaTime = deltaTime + 1
				end

				s.student:moveTo(s.sensibleAreas[s.animframe]);
				alive, dPower, dhp = evaluateLevel(s.sensibleAreas[s.animframe])

				s.deltaPower = s.deltaPower + dPower
				s.deltaHp = s.deltaHp + dhp
				if not alive then
					-- gameover
					s.playing = false
					s.gamefinished = false;
					s.gameover = true

					loadScene("gameover")

					-- call gameover game state
				else 
					-- check star bonus
					if s.deltaPower >= s.starTrashold then
						-- get star
						s.starEarned = true;
					end
				end
			end
			if s.bar then
				s.bar:setHealth(uservalues.currentHP)
				s.bar:setPower(uservalues.currentPower)
			end
		end

	end

end

function s.draw()
	love.graphics.draw(s.bg, 10, 135)
	for _, b in ipairs(uservalues.powerButtons) do
		if b.image then
			love.graphics.draw(b.image, b.x, b.y)
		end
		if b.name then
			local r, g, _b, a = love.graphics.getColor()
			love.graphics.setColor(0, 64, 0, 255)
			love.graphics.printf(b.name, b.x, b.y + b.w, b.w, "center")
			love.graphics.setColor(r, g, _b, a)
		end
		if b.qty then
			local r, g, _b, a = love.graphics.getColor()
			love.graphics.setColor(192, 0, 0, 255)
			love.graphics.print(b.qty, b.x, b.y)
			love.graphics.setColor(r, g, _b, a)

		end
	end
	for _, a in ipairs(s.sensibleAreas) do
		a:draw()
		if a.powerIdx then
			if s.playing or s.gamefinished then
				love.graphics.draw(a.altimage, a.x, a.y)
			else
				love.graphics.draw(a.image, a.x, a.y)
			end
		end
	end

	uservalues.resetButton:draw()

	uservalues.playButton:draw()

	s.bar:draw()

	s.student:draw()

	if s.gamefinished then
    s.playing = false
    uservalues.currentMiniGame = "minigame"
    if uservalues.currentPower >= 80 then
      loadScene("victory")
    else
      s.gameover = true
      loadScene("gameover")
    end
	end
end

function s.mousepressed(x, y, button)
	if s.gamefinished then
		loadScene("overview")
	else
		if not s.playing and not s.gameover then
			-- check power buttons
			for k, b in ipairs(uservalues.powerButtons) do
				if b:isInside(x, y) and b.qty > 0 then
					if k == s.curPower then
						s.curPower = nil
					else
						s.curPower = k
					end
				end
			end

			-- check sensible ares if there's a power selected
			if s.curPower then
				for k, a in ipairs(s.sensibleAreas) do
					if a:isInside(x, y) then
						if a.powerIdx ~= s.curPower then
							if a.powerIdx then
								uservalues.powerButtons[a.powerIdx].qty = uservalues.powerButtons[a.powerIdx].qty + 1
							end
							a.powerIdx = s.curPower
							a.image = uservalues.powerButtons[s.curPower].image
							a.altimage = uservalues.powerButtons[s.curPower].altimage
							uservalues.powerButtons[s.curPower].qty = uservalues.powerButtons[s.curPower].qty - 1
						end
						s.curPower = nil
					end
				end
			end

			--check reset button
			if uservalues.resetButton:isInside(x, y) then
				for k, a in ipairs(s.sensibleAreas) do
					if a.powerIdx then
						uservalues.powerButtons[a.powerIdx].qty = uservalues.powerButtons[a.powerIdx].qty + 1
						a.powerIdx = nil
					end
				end
			end

			if uservalues.playButton:isInside(x, y) then
				s.playing = true
			end
		end

	end
end

function s.keypressed(key, isrepeat)

	if s.gamefinished then
		if key == "return" then
			loadScene("overview")
		end

	else
		if not s.playing then
			if key == "escape" then
				if s.curPower then
					s.curPower = nil
				else
					love.event.quit()
				end
			end

			if key == "return" then
				s.playing = true;
			end
		end
	end

end

function s.playMiniGame()

end

return s

