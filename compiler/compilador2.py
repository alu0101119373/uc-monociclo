#!/usr/bin/env python3

import assembler as ass
import sys
from os import path

MAX_PROGRAM_SIZE = 1024

if len(sys.argv) != 3:
    print("ERROR! The compiler only takes two parameters!")
    exit()

inFile = sys.argv[1]
outFile = sys.argv[2]

if not path.exists(inFile):
    print("ERROR! File does not exist!")
    exit()

print()

print("Removing comments...")

inFile = ass.processComments(inFile)

print("Processing tags...")

inFile = ass.processTags(inFile)

print("Starting compilation process...\n")

# Leemos el fichero
cont = 0
oFile = open(outFile, "w")
with open(inFile) as iFile:
    for index, line in enumerate(iFile):
        fline = line.strip()
        # Procesamos la instruccion
        if len(fline) != 0:
            print("Processing instruction {:3}: {:15}, ".format(str(index+1).zfill(3), fline), end=" ")
            instruction = ass.divideInstruction(fline)
            if ass.isComplex(instruction):
                context = ass.ComplexContext()
                # Valoramos el tipo de instruccion que es
                context.setInstruction(ass.analyzeComplexInstruction(instruction))
                binary = context.toBinary(instruction)
                for index, ins in enumerate(binary):
                    oFile.write(ass.formatBinaryInstruction(ins) + '\n')
                    cont += 1
                    print("{:16}".format(ins), end="")
                    if index < len(binary) - 1:
                        print(",", end=" ")
                    else:
                        print()
            else:
                instruction = ass.process(instruction)
                binary = instruction.toBinary()
                oFile.write(ass.formatBinaryInstruction(binary) + '\n')
                cont += 1
                print(binary)

print("\nTotal processed instructions: {}\n".format(cont))

if cont < 1024:
    for i in range(cont+1, 1025):
        oFile.write("0000_0000_0000_0000\n")

oFile.close()

print("DONE!")