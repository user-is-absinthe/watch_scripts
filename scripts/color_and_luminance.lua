-- global variables
day_start = 7  -- полная подсветка с 7 утра
night_start = 20 - 1 -- до 20 вечера
darker_global = -0.5  -- затемнение на 50%

----------------------------------------------------------------
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
-- for tests

print(color_luminance("ff0000", 0.1))
