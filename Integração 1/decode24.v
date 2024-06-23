/* ----- ----- ----- ----- ----- -----
	Design: 2x4 Decoder
			By using primitives
 			for digital circuits
 	Filename: decode24.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 
`timescale 1 ns/100 ps
module decode24(
  input en,
  input A,B,
  output [3:0] Y
);
  wire nA,nB;
  not (nA,A);
  not (nB,B);
  and(Y[0],nA,nB,en);
  and(Y[1],nA,B,en);
  and(Y[2],A,nB,en);
  and(Y[3],A,B,en);
endmodule