Student = {}
local mt = {__index = Student}

function Student.new(sensibleArea)

	local r = {
	x = sensibleArea.x + sensibleArea.w,
	y = sensibleArea.y + sensibleArea.h,
	imag = nil
	}

	setmetatable(r, mt)

	r.imag = love.graphics.newImage("resource/image/student.png")

	r.y = r.y - r.imag:getHeight() * 0.2

	return r
end
setmetatable(Student, {__call = function(_, ...) return Student.new(...) end})

function Student.moveTo(self, sensibleArea)
	self.x = sensibleArea.x + sensibleArea.w
	self.y = sensibleArea.y + sensibleArea.h - self.imag:getHeight() * 0.2
end

function Student.draw(self)
	love.graphics.draw(self.imag, self.x, self.y, 0, -0.2, 0.2)
end
