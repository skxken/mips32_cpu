`timescale 1ns / 1ps

module MemOrIO(
    mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl,ScanCtrl
    );

    input mRead;
    input mWrite;
    input ioRead;
    input ioWrite;
    input[31:0] addr_in;
    
    input[31:0] m_rdata; 
    input[15:0] io_rdata;
    input[31:0] r_rdata;

    output[31:0] r_wdata; 
    output[31:0] addr_out; 
    output reg[31:0] write_data; 
    output LEDCtrl; 
    output SwitchCtrl; 
    output ScanCtrl;

    assign addr_out= addr_in;

    assign r_wdata=(ioRead==1'b1)?io_rdata:m_rdata; 
 
    assign LEDCtrl= (ioWrite == 1'b1 && (addr_in== 32'hFFFFFC60 || addr_in== 32'hFFFFFC62))?1'b1:1'b0;  // led 模块的片选信号，高电平有�?; 
    assign ScanCtrl=(ioWrite == 1'b1 && addr_in== 32'hFFFFFC80)?1'b1:1'b0;

    assign SwitchCtrl= (ioRead == 1'b1)?1'b1:1'b0;


    always @* begin
        if((mWrite==1)||(ioWrite==1))
            write_data =  ((mWrite == 1'b1)?r_rdata:{16'b0000000000000000,r_rdata[15:0]});
        else
            write_data = 32'hZZZZZZZZ;
    end

endmodule
