`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/20 11:04:26
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ControllerIO(
    input [5:0]Opcode, 
    input [5:0]Function_opcode,  
    output Jr,      
    output Jmp,    
    output Jal,    
    output Branch,     
    output nBranch,    
    output RegDST,    

    output RegWrite,       
    output MemWrite,       
    output ALUSrc,      
    output I_format,     
    output Sftmd,       
    output [1:0] ALUOp,

   
    input [21:0] Alu_resultHigh,    
    output MemorIOtoReg,    
    output MemRead,    
    output IORead,      
    output IOWrite    
    );

    wire R_format;
    wire Lw;
    wire Sw;

assign MemWrite = ((Sw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0; 
assign R_format=(Opcode==6'b000000)?1'b1:1'b0;

//out
assign RegDST=R_format;
assign I_format=(Opcode[5:3]==3'b001)?1'b1:1'b0;   
assign RegWrite=(R_format||Lw||Jal||I_format)&&!(Jr);

assign ALUOp={(R_format||I_format),(Branch||nBranch)};

assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)
||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)
||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))
&& R_format)? 1'b1:1'b0;
assign ALUSrc=((I_format&&!(Branch||nBranch))||Lw||Sw);

assign Jr=({Opcode,Function_opcode}==12'b000000_001000)?1'b1:1'b0;
assign Jal=(Opcode==6'b000011)?1'b1:1'b0;
assign Jmp=(Opcode==6'b000010)?1'b1:1'b0;

assign Branch=(Opcode==6'b000100)?1'b1:1'b0;
assign nBranch=(Opcode==6'b000101)?1'b1:1'b0;

assign Lw=(Opcode==6'b100011)?1'b1:1'b0;
assign Sw=(Opcode==6'b101011)?1'b1:1'b0;


    assign MemRead = ((Lw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;  
    assign IORead = ((Lw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0; 
    assign IOWrite = ((Sw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0; 

    assign MemorIOtoReg = IORead || MemRead;
endmodule