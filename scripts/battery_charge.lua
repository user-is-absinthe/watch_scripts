charger = false
charge_color = "0000FF"  -- синий


----------------------------------------------------------------
function var_part_circle(percent, all_angle, start_angle)
--var_part_circle({bl}}, 180, 180)
	return start_angle + percent * all_angle / 100
end


function var_color_charge(percent, charger)
--var_color_charge({bl})
--var_color_charge({bl}, true)
	-- сделаем плавный переход из зеленого в красный
	-- для этого возьмем зеленый 00FF00 и за 100
	-- шагов сделаем из него красный
	-- //"Как я стал красным всего за 100 шагов?"
	--		 Pre-order now from 99$!//
	if charger then
		-- если на зарядке, вернем цвет по умолчанию
		return charge_color
	end
	if percent >= 50 then
		red = 255 * (100 - percent) / 50
		green = 255
	else
		green = 255 * percent / 50
		red = 255
	end

	red = string.format('%x', tostring(math.floor(red)))
	green = string.format('%x', tostring(math.floor(green)))

    if string.len(red) == 1 then
        red = "0" .. red
    elseif string.len(red) == 0 then
        red = "00"
    end
    if string.len(green) == 1 then
        green = "0" .. green
    elseif string.len(green) == 0 then
        green = "00"
    end

	end_line = red .. green .. "00"
	return end_line
end
----------------------------------------------------------------
-- tests
print(var_color_charge(25))