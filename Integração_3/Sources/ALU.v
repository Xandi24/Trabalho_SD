/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module:	ALU ( Arithmetic-Logic Unit)
 	Filename: ALU.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
			Gabriel DezejÃ¡como Maruschi(14571525)
			Matheus Cavalcanti de Santana(13217506)
			Vitor Pardini Saconi(14611800)
			Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /july_2024/
	----- ----- ----- ----- ----- -----
*/

module ALU #(parameter Size=8)(
  input [Size-1:0] A,B,
  input [1:0] funct,
  output [Size-1:0] ALUOut,
  output zero
);
  wire [Size-1:0] a [3:0];
  
  
  adder #(Size) som (.mode(funct[0]), .A(A), .B(B), .Cin(0), .Cout(), .S(a[0]) );
  adder #(Size) sub (.mode(funct[1]), .A(A), .B(B), .Cin(0), .Cout(), .S(a[1]) );
  
  and (a[2],A,B);
  or(a[3],A,B);
  
  mux41 #(Size) select ( .y(ALUOut), .s(funct), .a3(a[3]), .a2(a[2]), .a1(a[1]), .a0(a[0]) );
  
  assign zero = ALUOut? 0:1;
  
endmodule
/********************************************************************************/