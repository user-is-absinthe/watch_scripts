-- global variables from battery_charge.lua
charger = false
charge_color = "0000FF"  -- синий

-- global variables from color_and_luminance.lua
day_start = 7  -- полная подсветка с 7 утра
night_start = 20 - 1 -- до 20 вечера
darker_global = -0.5  -- затемнение на 50%

----------------------------------------------------------------
-- battery_charge.lua

function var_part_circle(percent, all_angle, start_angle)
--var_part_circle({bl}, 180, 180)
	return start_angle + percent * all_angle / 100
end

function var_color_charge(percent, charger)
--var_color_charge({bl})
--var_color_charge({bl}, '{bc}')
	-- сделаем плавный переход из зеленого в красный
	-- для этого возьмем зеленый 00FF00 и за 100
	-- шагов сделаем из него красный
	-- //"Как я стал красным всего за 100 шагов?"
	--		 Pre-order now from 99$!//
	if charger == "Charging" then
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

function var_charge_flashing(persent, status)
--var_charge_flashing({bl}, '{bc}')
	if percent ~= 100 and status == "Charging" then
		return {drss} % 6 < 3 and 0 or 100
	end
end

----------------------------------------------------------------
-- color_and_luminance.lua

-- работа с затемнением
function var_opacity(hour, adjust)
--var_opacity({dh23}, {abright})
    if hour >= day_start and hour <= night_start then
        return '100'
    else
        if adjust then
            return '50'
        else
            return '20'
        end
    end
end

function var_opacity_gif(hour)
--var_opacity_gif({dh23})
    if hour >= day_start and hour <= night_start then
        return '100'
    else
        return '0'
    end
end

function var_color(hour, color, darker)
--var_color_main({dh23}, 'ffffff')
--var_color_main({dh23}, 'ffffff', -0.1)
-- darker = -0.5  -- сила затемнения / темнее на 50%
    if hour >= day_start and hour <= night_start then
        return color
    else
        -- если не задан конкретный параметр затемнения,
        -- используем глобальный
        return var_color_luminance(color, darker or darker_global)
    end
end

function var_color_luminance(hex_code, lum)
--var_color_luminance(FFFFFF, 0.1)
-- lum = -0.1 темнее на 10%
-- lum = 0.1 светлее на 10%
    couple = {hex_code:match('(..)(..)(..)')}
    exit_line = ""
    for i = 1, 3 do
        temp = tonumber(couple[i], 16)
        temp = human_round(math.min(math.max(0, temp + temp * lum), 255))
        temp = string.format('%x', tostring(temp))
        if string.len(temp) == 1 then
            temp = "0" .. temp
        elseif string.len(temp) == 0 then
            temp = "00"
        end
        exit_line = exit_line .. temp
    end
    return exit_line
end

function human_round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

----------------------------------------------------------------
-- plane_text.lua

-- работа с временем
function var_time_h(time_h)
--var_time_h({dh23})
    line_h = separate_number(time_h, true)
    full_line_h = ""
    if time_h >= 5 and time_h <= 20 or time_h == 0 then
        full_line_h = line_h .. "\nчасов"
    elseif time_h == 1 or time_h == 21 then
        full_line_h = line_h .. "\nчас"
    elseif time_h == 2 or time_h == 3 or time_h == 4 or time_h == 22 or time_h == 23 then
        full_line_h = line_h .. "\nчаса"
    end
    
    return full_line_h
end

function var_time_m(time_m, flag)
--var_time_m({dmz}, true) - минуты
--var_time_m({dsz}, false) - секунды
    line_m = separate_number(time_m, false)
    full_line_m = ""
    temp = ""
    if flag then
        temp = "минут"
    else
        temp = "секунд"
    end
    if time_m == 0 then
        full_line_m = line_m .. "\n" .. temp
    elseif time_m % 10 == 1 and time_m ~= 11 then
        full_line_m = line_m .. "\n" .. temp .. "a"
    elseif (time_m % 10 == 2 or time_m % 10 == 3 or time_m % 10 == 4) and 
            (time_m ~= 11 and time_m ~= 12 and time_m ~= 13) then
        full_line_m = line_m .. "\n" .. temp .. "ы"
    else
        full_line_m = line_m .. "\n" .. temp
    end
    return full_line_m
end

function separate_number(number, flag)
    -- flag = true если часы
    -- flag = false если минуты
    -- 1 час, 2 часа, 3 часа, 4 часа
    -- 1 минута, 2 минуты, 3 минуты, 4 минуты
    first_digit = math.floor(number / 10)
    second_digit = number % 10
    first_line = ""
    if first_digit == 0 then
        first_line = ""

    elseif first_digit == 1 and second_digit == 0 then
        first_line = "десять"
    elseif first_digit == 1 and second_digit == 1 then
        first_line = 'одиннадцать'
    elseif first_digit == 1 and second_digit == 2 then
        first_line = 'двенадцать'
    elseif first_digit == 1 and second_digit == 3 then
        first_line = 'тринадцать'
    elseif first_digit == 1 and second_digit == 4 then
        first_line = 'четырнадцать'
    elseif first_digit == 1 and second_digit == 5 then
        first_line = 'пятнадцать'
    elseif first_digit == 1 and second_digit == 6 then
        first_line = 'шестнадцать'
    elseif first_digit == 1 and second_digit == 7 then
        first_line = 'семнадцать'
    elseif first_digit == 1 and second_digit == 8 then
        first_line = 'восемнадцать'
    elseif first_digit == 1 and second_digit == 9 then
        first_line = 'девятнадцать'

    elseif first_digit == 2 then
        first_line = "двадцать"
    elseif first_digit == 3 then
        first_line = "тридцать"
    elseif first_digit == 4 then
        first_line = "сорок"
    elseif first_digit == 5 then
        first_line = "пятьдесят"
    end

    second_line = ""
    if second_digit == 0 and first_digit ~= 1 then
        second_line = ""

    elseif second_digit == 1 and first_digit ~= 1 and flag then
        second_line = "один"
    elseif second_digit == 2 and first_digit ~= 1 and flag  then
        second_line = "два"
    elseif second_digit == 1 and first_digit ~= 1 and not flag  then
        second_line = "одна"
    elseif second_digit == 2 and first_digit ~= 1 and not flag  then
        second_line = "две"

    elseif second_digit == 3 and first_digit ~= 1 then
        second_line = "три"
    elseif second_digit == 4 and first_digit ~= 1 then
        second_line = "четыре"
    elseif second_digit == 5 and first_digit ~= 1 then
        second_line = "пять"
    elseif second_digit == 6 and first_digit ~= 1 then
        second_line = "шесть"
    elseif second_digit == 7 and first_digit ~= 1 then
        second_line = "семь"
    elseif second_digit == 8 and first_digit ~= 1 then
        second_line = "восемь"
    elseif second_digit == 9 and first_digit ~= 1 then
        second_line = "девять"
    end

    if first_digit == 0 and second_digit == 0 then
        first_line = "ноль"
        second_line = ""
    end

    if (first_line ~= "") and (second_line ~= "") then
        return first_line .. " " .. second_line
    elseif first_line == "" then
        return second_line
    elseif second_line == "" then
        return first_line
    else
        return "технические\nшоколадки"
    end
end

