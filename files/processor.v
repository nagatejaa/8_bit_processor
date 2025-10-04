`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nagateja
// Create Date: 04.10.2025 12:21:23
// Design Name: A processor with 16bit instruction 8bit registers
// Module Name: processor
//////////////////////////////////////////////////////////////////////////////////


module processor(
    input clk,rst,
    output [3:0] flags 
);


//Instances related to register file
wire w;
wire [7:0]alu_res;
wire [7:0]ra,rb;
wire [2:0]radda,raddb,wadd;

//program counter
reg [7:0]pc;

reg [15:0] instruction;

//instances related to alu
wire [2:0] shift_amt;    // shift amount
wire cin;
wire [3:0]opcode;
wire [3:0]alu_flags_out;
reg [7:0]value;
wire [7:0]B;
wire [7:0]alu_final_res;

reg [3:0] flag_reg; 

parameter LDI = 4'b1111;
parameter ADD = 4'b0000;
parameter SUB = 4'b0001;
parameter AND = 4'b0010;
parameter OR =  4'b0011;
parameter XOR = 4'b0100;
parameter NOT = 4'b0101;
parameter INC = 4'b0110;
parameter DEC = 4'b0111;
parameter SHL = 4'b1000;
parameter SHR = 4'b1001;
parameter ROL = 4'b1010;
parameter ROR = 4'b1011;
parameter MUL = 4'b1101;

parameter CLR = 4'b1100;




parameter R0 = 3'd0;
parameter R1 = 3'd1;
parameter R2 = 3'd2;
parameter R3 = 3'd3;
parameter R4 = 3'd4;
parameter R5 = 3'd5;
parameter R6 = 3'd6;
parameter R7 = 3'd7;



parameter EMP = 3'd0;
parameter EMPC = 9'd0;

 

reg_file regfile (
    .clk(clk),
    .w(w),
    .wdata(value), 
    .ra(ra),
    .rb(rb),
    .radda(radda),
    .raddb(raddb),
    .wadd(wadd)
);

alu alu(
    .res(alu_res), 
    .MSB(B),
    .flag(alu_flags_out),
    .a(ra),
    .b(rb),
    .cin(1'b0),
    .opcode(opcode),
    .shift_amt(shift_amt)
);



// program counter block
always @(posedge clk) begin
    if (rst) 
        pc  <= 8'h00;
    else
        pc <= pc + 1;    
end


//since the pc is 8 bits 2^8 256 means 0 to 255 instructions should be there
//imagine pc as page number means it can count from 0 to 255 
// and executes each page
reg [15:0] instruction_memory [0:255];
///////////////////////////////////////////////////////////////////////////////////////////////
//
//why 15:0?
//that represents 16bit instruction set
//opcode is 4 bits
//rega address is 3 bits
//regb address is 3 bits
//output will be stored in ine register whose address is also 3 bits so output is 3 bits
//total 13bit we cant make 13bits so i used 16 bit where 3 bits are unused
//
///////////////////////////////////////////////////////////////////////////////////////////////
initial begin


 
        
          instruction_memory[0] = {LDI, R0, 9'd10};
          instruction_memory[1] = {LDI, R1, 9'd30};
          instruction_memory[2] = {ADD, R2, R0, R1, EMP};
          instruction_memory[3] = {ADD, R3, R2, R1, EMP};
          instruction_memory[4] = {SUB, R4, R3, R0, EMP};
          instruction_memory[5] = {AND, R5, R1, R3, EMP};
          instruction_memory[6] = {OR, R6, R1, R5, EMP};
          instruction_memory[7] = {INC, R0, EMPC};
          instruction_memory[8] = {LDI, R7, 9'd4};
          instruction_memory[9] = {MUL, R1, R0, R7, EMP};
          instruction_memory[10] = {CLR, R4, EMPC};
          instruction_memory[11] = {MUL, R2, R1, R7, EMPC};


          
//          instruction_memory[9] = {SHL, R7, R7, EMP, 3'b001};
//          instruction_memory[10] = {SHL, R7, R7, EMP, 3'b001};
//          instruction_memory[11] = {SHL, R7, R7, EMP, 3'b001};
//          instruction_memory[12] = {SHL, R7, R7, EMP, 3'b001};
          


       

end

    always @(*) instruction = instruction_memory[pc];

    // --- Instruction Decode ---
    assign opcode = instruction[15:12];
    assign wadd   = instruction[11:9];
    assign radda  = (opcode == INC || opcode == DEC) ? wadd : instruction[8:6];
    assign raddb  = instruction[5:3];
    assign shift_amt = instruction[2:0];
    
     
    wire [8:0] immediate_val = instruction[8:0];
 

    assign w = (opcode == LDI || opcode == ADD || opcode == SUB || opcode == AND || opcode == OR || opcode == XOR ||
            opcode == NOT || opcode == INC || opcode == DEC || opcode == SHL || opcode == SHR || opcode == ROL ||
            opcode == ROR || opcode == CLR || opcode == MUL);

   
    // This single block now correctly decides what 'value' should be written to the register file.
    always @(*) begin
        case (opcode)
            LDI:    value = immediate_val[7:0];
            CLR:    value = 8'h00;
            default: value = alu_res;
        endcase
    end
    
    
   always @(posedge clk) begin
        if (rst) begin
            flag_reg <= 4'b0000;
        end else begin
            // Only update the flags on an ADD instruction.
            // For LDI, the flags will not change.
            if (opcode == ADD || opcode == SUB) begin
                flag_reg <= alu_flags_out;
            end
        end
    end

    // Connect the internal register to the module's output port
    assign flags = flag_reg;
    
endmodule
