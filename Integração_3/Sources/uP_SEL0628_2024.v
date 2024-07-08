/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module:	third integration
 	Filename: uP_SEL0628_2024.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
		Gabriel Dezejácomo Maruschi(14571525)
		Matheus Cavalcanti de Santana(13217506)
		Vitor Pardini Saconi(14611800)
		Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /july_2024/
	----- ----- ----- ----- ----- -----
*/

module uP_SEL0628_2024 (
	input clk, clr_n,
	input [7:0] data_in,
	output we,
	output [5:0] addr,
	output [7:0] data_out
);

	wire PC_en, PC_ld, LdSt, IR_en, Wb, RF_we, Zero;
	wire [1:0] a1, a2, ALU_Control;
	wire [5:0] PC_out;
	wire [7:0] IR_out, ALUOut, wd, rd1, rd2;

  	counter #(6) PC (.clk(clk), .clr_n(clr_n), .en(PC_en), .ld(PC_ld), .D(IR_out[5:0]), .Q(PC_out));
	
  	mux21 #(6) MEM_ADR (.s(LdSt), .a0(PC_out), .a1(IR_out[5:0]), .y(addr));
	
	register #(8) IR (.clk(clk), .clr_n(clr_n), .en(IR_en), .D(data_in), .Q(IR_out));
	
	fsm UC (.clk(clk), .clr_n(clr_n), .instr(IR_out), .Zero(Zero), .PC_en(PC_en) ,.PC_ld(PC_ld), .LdSt(LdSt), .we(we), .IR_en(IR_en), .Wb(Wb), .RF_en(RF_we), .A1(a1), .A2(a2), .ALU_Control(ALU_Control));
	
  	regbank #(.Size(8), .nreg(4)) REGFILE (.clk(clk), .clr_n(clr_n), .we(RF_we), .a1(a1), .a2(a2), .wd(wd), .rd1(rd1), .rd2(rd2));
	
	ALU #(8) ula (.funct(ALU_Control), .A(rd1), .B(rd2), .ALUOut(ALUOut), .zero(Zero));

	mux21 #(8) WR_BCK (.s(Wb), .a0(ALUOut), .a1(data_in), .y(wd));
	
	assign data_out = rd2;
	
endmodule
/********************************************************************************/  

