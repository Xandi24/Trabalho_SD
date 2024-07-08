// Code your testbench here
// or browse Examples
`timescale 1ns / 1ns

module test_bench;
	
wire [7:0] datain, dataout;
wire [5:0] adress;
wire we;
reg rst,clk;

uP_SEL0628_2024 dut (.clk(clk), .clr_n(rst), .data_in(dataout), .we(we), .addr(adress), .data_out(datain));
RamChip  ram (adress, datain, dataout, 1'b0, ~we, 1'b0);

initial begin
	clk <= 0;
	rst <= 1;
	#50;
	clk <= 0;
	rst <= 0;
	#50;
	clk <= 1;
	#25;
	rst <= 1;
	#25;
	end
		
initial // Clock generator
	begin
   forever #50 clk = !clk;
  end

initial
  begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
endmodule

// RAM Model
//
// +-----------------------------+
// |    Copyright 1996 DOULOS    |
// |       Library: Memory       |
// |   designer : John Aynsley   |
// +-----------------------------+

module RamChip (Address, Datain, Dataout, CS, WE, OE);

parameter AddressSize = 6;
parameter WordSize = 8;

input [AddressSize-1:0] Address;
input [WordSize-1:0] Datain;
output [WordSize-1:0] Dataout;
input CS, WE, OE;

reg [WordSize-1:0] Mem [0:1<<AddressSize];

assign #5 Dataout = (!CS && !OE) ? Mem[Address] : {WordSize{1'bz}};  

initial begin  // pre-program the ram
	//LD = 2'b00, ST = 2'b01, ALU = 2'b10, JC = 2'b11 (00 ADD, 01 SUB, 10 AND, 11 OR)
	Mem[00] = 8'b00001111;	//LD [15]	
	Mem[01] = 8'b10010101;	//MOV R1, R0	//SUB R1, R1
	Mem[02] = 8'b10000100;					//ADD R1, R0
	Mem[03] = 8'b10000101;	//ADD R1, R1
	Mem[04] = 8'b10000101;	//ADD R1, R1
	Mem[05] = 8'b10010100;	//SUB R1, R0
	Mem[06] = 8'b11000101;	//JNZ [05]
	Mem[07] = 8'b01001110;	//ST [14]
	Mem[08] = 8'b10100000;	//AND R0, R0
	Mem[09] = 8'b11001000;	//JNZ [08]
	Mem[14] = 8'b00000000;	//Result
	Mem[15] = 8'b00000100;	//Data
	
end

always @(CS or WE)
  if (!CS && !WE) begin
    Mem[Address] = Datain;
	$monitor("mem[14]=",Mem[14],"\n");
  end

endmodule

