----------------------------------------------------------------
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
