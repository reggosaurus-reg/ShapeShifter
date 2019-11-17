local alphabet = "abcdefghijklmnopqrstuvwxyz0123456789"
is_character = function(key) return string.find(alphabet, key) end

local yf_font = "res/yf16font.ttf"
big_font = love.graphics.newFont(yf_font, 55)
medium_font = love.graphics.newFont(yf_font, 35)
small_font = love.graphics.newFont(yf_font, 15)
small_font:setFilter( "nearest", "nearest" )
medium_font:setFilter( "nearest", "nearest" )
big_font:setFilter( "nearest", "nearest" )

function write_centered(text, font, y, win_w)
	local w = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.print(text, (win_w - w) / 2, y)
end

function write_right(text, font, win_w, margin)
	local w = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.print(text, win_w - w - 2*margin, margin)
end

function write(text, font, x, y)
	local w = font:getWidth(text)
	love.graphics.setFont(font)
	love.graphics.print(text, x, y)
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

