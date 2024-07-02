/* ----- ----- ----- ----- ----- -----
	Design: 2x1 Multiplexer
			By using conditional descripition
 			for digital circuits
 	Filename: mux21.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 
`timescale 1 ns/100 ps

module mux21 
  #(parameter Size=8)
  (output[Size-1:0]y, input s, input [Size-1:0] a1, a0);
	assign y= s? a1:a0;
endmodule