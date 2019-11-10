function write_centered(text, font, y, win)
	local w = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.print(text, (win - w) / 2, y)
end

function write_right(text, font, win_w, margin)
	local w = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.print(text, win_w - w - 2*margin, margin)
end

function time_to_string(time)
	time = math.ceil((time * 100)) / 100
	local time = ""..time
	if #time == 1 then
		return time..".00"
	elseif #time== 3 then
		return time.."0"
	else 
		return time
	end
end
