`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 19:03:34
// Design Name: 
// Module Name: Idecoder32
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


module Decoder(
    input [31:0]  Instruction,
    input [31:0]  read_data,
    input [31:0]  ALU_result,
    input Jal,RegWrite,MemtoReg,RegDst,clock,reset,
    input [31:0]  opcplus4,
    output wire [31:0] read_data_1,
    output wire [31:0] read_data_2,
    wire [31:0] imme_extend
);

    reg[31:0] register[0:31];

    wire[4:0] rs;
    wire[4:0] rt;
    wire[4:0] rd;
    wire[15:0] immediate_number;
    wire[5:0] opcode;
    reg[4:0] write_register_address;
    reg[31:0] write_data;

    assign opcode=Instruction[31:26];

    assign rs=Instruction[25:21];     
    assign rt=Instruction[20:16];       
    assign rd=Instruction[15:11];
    assign read_data_1=register[rs];    
    assign read_data_2=register[rt];

    assign immediate_number[15:0]=Instruction[15:0];
    assign imme_extend[15:0]=immediate_number[15:0];
    assign imme_extend[31:16]=(immediate_number[15]==1'b0)? 16'h0000:16'hFFFF;

    always @* begin   
        if (Jal) begin
            write_data=opcplus4;
        end
        else if(MemtoReg) begin
            write_data=read_data;
        end
        else begin
            write_data=ALU_result;
        end
    end

    always @* begin
        if (Jal) begin
            write_register_address=5'b11111;
        end
        else if (RegDst) begin
            write_register_address=rd;
        end
        else begin
            write_register_address=rt;
        end
    end

    integer i;
    always @(posedge clock) begin    
        if(reset) begin    
            for(i=0;i<32;i=i+1)
                register[i] <= 0;
        end
        else if (RegWrite && write_register_address != 0) begin    
            register[write_register_address] <= write_data;
        end
    end


endmodule

