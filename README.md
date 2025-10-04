# 8-Bit Processor

This project implements an 8-bit processor with the following features:

- **16-bit instruction width**
- **258 lines of instruction memory**
- **8 general-purpose 8-bit registers**
- **Arithmetic operations:** Addition, Subtraction, Multiplication (using Booth's algorithm)
- **Logical operations:** AND, OR, XOR, NOT, etc.

## Schematic

You can view the processor schematic in the PDF linked below:

[Processor Schematic](/schematic.pdf)

## Output Example

Below is an example output image showing the processor in operation:

![Processor Output](/processor_output.png)

## Example Program

Here is a sample program loaded into instruction memory:

```verilog
instruction_memory[0]  = {LDI, R0, 9'd10};         // Load 10 into R0
instruction_memory[1]  = {LDI, R1, 9'd30};         // Load 30 into R1
instruction_memory[2]  = {ADD, R2, R0, R1, EMP};   // R2 = R0 + R1
instruction_memory[3]  = {ADD, R3, R2, R1, EMP};   // R3 = R2 + R1
instruction_memory[4]  = {SUB, R4, R3, R0, EMP};   // R4 = R3 - R0
instruction_memory[5]  = {AND, R5, R1, R3, EMP};   // R5 = R1 & R3
instruction_memory[6]  = {OR, R6, R1, R5, EMP};    // R6 = R1 | R5
instruction_memory[7]  = {INC, R0, EMPC};          // Increment R0
instruction_memory[8]  = {LDI, R7, 9'd4};          // Load 4 into R7
instruction_memory[9]  = {MUL, R1, R0, R7, EMP};   // R1 = R0 * R7
instruction_memory[10] = {CLR, R4, EMPC};          // Clear R4
instruction_memory[11] = {MUL, R2, R1, R7, EMPC};  // R2 = R1 * R7
```

## Features

- **Instruction Set:** Supports arithmetic and logical instructions.
- **Multiplication:** Efficient Booth's algorithm implementation.
- **Register File:** 8 registers for flexible data manipulation.
- **Instruction Memory:** 258 lines for program storage.

## Getting Started

1. Clone the repository.
2. Open the project in Vivado.
3. Synthesize and implement the design.
4. Load your program into instruction memory.

