
/* ----- ----- ----- ----- ----- -----
	Design: 4x1 Multiplexer
			By using conditional descripition
 			for digital circuits
 	Filename: mux41.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 
module mux41 #(parameter Size=8)(
   output[Size-1:0]y, 
  input [1:0] s,
  input [Size-1:0] a3, a2, a1, a0
);
  wire [Size-1:0] d [1:0];
  mux21#(Size) d0 (d[0], s[0], a1 ,a0);
  mux21#(Size) d1 (d[1], s[0], a3, a2);
  assign y= s[1]? d[1]:d[0];
endmodule