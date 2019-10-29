import os
import re


END_FILENAME = '[all] functions.lua'
ORDINARY_SPLIT = '----------------' + \
                 '----------------' + \
                 '----------------' + \
                 '----------------'


files_in_directory = os.listdir()
# убираем лишнее: файлы с префиксами, "!_*", отбираем только *.lua
lua_names = list()
lua_global_variables = list()
lua_functions = list()
for file_name in files_in_directory:
    if '.lua' in file_name \
            and not ('[' in file_name or ']' in file_name):
        lua_names.append(file_name)
        with open(file_name, 'r') as file:
            lines = file.read()
        # name, +globals, +function, -tests
        pieces = lines.split(ORDINARY_SPLIT)
        lua_global_variables.append(pieces[0])
        lua_functions.append(pieces[1])
# saved
with open(END_FILENAME, 'w') as file:
    to_write = str()
    for index, global_var in enumerate(lua_global_variables):
        if global_var == '':
            continue
        else:
            to_write += '-- global variables from ' + lua_names[index] + '\n'
            to_write += global_var.replace('-- global variables\n', '') + '\n'
    
    to_write += '\n\n'

    for index, name in enumerate(lua_names):
        to_write += ORDINARY_SPLIT + '\n'
        to_write += '-- ' + name + '\n'
        to_write += lua_functions[index] + '\n'
        to_write += '\n\n'

    to_write = re.sub(r'\n+\n+', r'\n\n', to_write)
    file.write(to_write)
