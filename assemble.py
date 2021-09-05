import os.path
import sys

print('Assembling machine code... please enter input file name without the extension')
print('ex: just enter prac for prac.txt')
file_name = input()
file_name_ext = file_name + ".txt"

def func_0(str_array):
    instruction = str_array[0]
    registers = str_array[1:]
    opcode = "0"
    reg = ""
    
    if instruction == "add":
        func = "00"
    elif instruction == "xor":
        func = "01"
    elif instruction == "shift":
        func = "10"
    elif instruction == "and":
        func = "11"
    else:
        print("error: " + instruction + registers)
        
    if len(registers) == 3:
        for r in registers:
            if r == "r0":
                reg += "00"
            elif r == "r1":
                reg += "01"
            elif r == "r2":
                reg += "10"
            elif r == "r3":
                reg += "11"
            elif "#" in r:
                temp = r.replace("#","")
                reg += str(format(int(temp), "b"))
            else:
                print("error: " + instruction + r)
    else:
        for r in registers:
            if r == "r0":
                reg += "000"
            elif r == "r1":
                reg += "001"
            elif r == "r2":
                reg += "010"
            elif r == "r3":
                reg += "011"
            elif r == "r4":
                reg += "100"
            elif r == "r5":
                reg += "101"
            elif r == "r6":
                reg += "110"
            elif r == "r7":
                reg += "111"
            elif "#" in r:
                # reg += "111"
                temp = r.replace("#","")
                reg += str(format(int(temp), "b"))
            else:
                print("error: " + instruction + r)
            
    return_txt = ''.join([opcode, func, reg])
    if len(return_txt) < 9:
        temp_len = 9 - len(return_txt)
        add_on = ""
        for i in range(temp_len):
            add_on += "1"
        temp = ''.join([return_txt, add_on])
        return_txt = temp
    return return_txt

def func_1(str_array):
    instruction = str_array[0]
    opcode = "1"
    registers = str_array[1:]
    reg = ""
    
    if instruction == "lw":
        func = "00"
    elif instruction == "sw":
        func = "01"
    elif instruction == "bne":
        func = "10"
    else:
        print("error: " + instruction + registers)
        
    if len(registers) > 1:
        for r in registers:
            if r == "r0":
                reg += "000"
            elif r == "r1":
                reg += "001"
            elif r == "r2":
                reg += "010"
            elif r == "r3":
                reg += "011"
            elif r == "r4":
                reg += "100"
            elif r == "r5":
                reg += "101"
            elif r == "r6":
                reg += "110"
            elif r == "r7":
                reg += "111"
            elif "#" in r:
                # reg += "111"
                temp = r.replace("#","")
                reg += str(format(int(temp), "b"))
            else:
                print("error: " + instruction + r)
                
    elif len(registers) == 1:
        if registers[0] == "r0":
            reg = "000000"
        elif registers[0] == "r1":
            reg = "000001"
        elif registers[0] == "r2":
            reg = "000010"
        elif registers[0] == "r3":
            reg = "000011"
        elif registers[0] == "r4":
            reg = "000100"
        elif registers[0] == "r5":
            reg = "000101"
        elif registers[0] == "r6":
            reg = "000110"
        elif registers[0] == "r7":
            reg = "000111"
        elif registers[0] == "r8":
            reg = "001000"
        elif registers[0] == "r9":
            reg = "001001"
        elif registers[0] == "r10":
            reg = "001010"
        elif registers[0] == "r11":
            reg = "001011"
        elif registers[0] == "r12":
            reg = "001100"
        elif registers[0] == "r13":
            reg = "001101"
        elif registers[0] == "r14":
            reg = "001110"
        elif registers[0] == "r15":
            reg = "001111"
        elif "step_" in registers[0]:
            temp = registers[0].replace("step_","")
            temp = temp.replace(":","")
            reg += str(format(int(temp), "b"))
    else:
        print("error: " + instruction + registers)

    return_txt = ''.join([opcode, func, reg])
    if len(return_txt) < 9:
        temp_len = 9 - len(return_txt)
        add_on = ""
        for i in range(temp_len):
            add_on += "1"
        temp = ''.join([return_txt, add_on])
        return_txt = temp
    return return_txt

def func_shift(str_array):
    if len(str_array) != 4:
        print(str_array)
        print("\nhelp")
        return("help")
    opcode = "1"
    func = "10"
    
    register = str_array[2]
    direction = str_array[1]
    value = str_array[3]
    
    r_register = ""
    r_direction = ""
    r_value = ""
    
    if register == "r0":
        r_register = "00"
    elif register == "r1":
        r_register = "01"
    elif register == "r2":
        r_register = "10"
    elif register == "r3":
        r_register = "11"
    else:
        print(register)
        
    if direction == "left":
        r_direction = "00"
    elif direction == "right":
        r_direction == "01"
    else:
        print("error: " + direction)
        
    if value == "0":
        r_value = "00"
    elif value == "1":
        r_value = "01"
    elif value == "2":
        r_value = "10"
    elif value == "3":
        r_value = "11"
    else:
        print("error: " + value)
    
    return_txt = ''.join([opcode, func, r_register, r_direction, r_value])
    if len(return_txt) < 9:
        temp_len = 9 - len(return_txt)
        add_on = ""
        for i in range(temp_len):
            add_on += "1"
        temp = ''.join([return_txt, add_on])
        return_txt = temp
    return return_txt

assembly_file  = open(file_name_ext, "r")
x_lines = []

for line in assembly_file:
    str_array = line.split()
    instruction = str_array[0]
    
    if instruction == "//":
      continue
    elif instruction == "add" or instruction == "xor" or instruction == "and":
        return_txt = func_0(str_array)
    elif instruction == "lw" or instruction == "sw" or instruction == "bne":
        return_txt = func_1(str_array)
    elif instruction == "shift":
        return_txt = func_shift(str_array)
    elif instruction == "stp":
        return_txt = "111111111"
    elif "step_" in instruction:
        temp = instruction.replace("step_","")
        temp = temp.replace(":","")
        return_txt += str(format(int(temp), "b"))
        continue
    else:
        print("error: undefined opcode " + instruction)
        return_txt = instruction
    x_lines.append(return_txt)

new_name = file_name + "_mach.txt"
machine_file = open(new_name, "w")
for code in x_lines:
    machine_file.write(code + "\n")
machine_file.close()
assembly_file.close()