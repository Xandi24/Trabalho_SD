/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module: Somator n bits
			By using loop with 1bit somator
 			for digital circuits
 	Filename: adder.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 

module add_1bit(
  input fA, //adaptação necessária para poder selecionar adição ou subtração 
  input A,B,
  input Cin,
  output S,
  output Cout
);
  assign S = A^B^Cin;
  assign Cout= (fA & B) | (fA & Cin) | (B & Cin);
endmodule


module adder #(parameter Size=8)(
  input  mode, // mod=0 -> somador (A+B). mod=1 -> subtrator (A-B) 
  input [Size-1:0]  A,B,
  input Cin,
  output Cout,//carry
  output [Size-1:0] S
);
  
  wire [Size:0] c ;
  wire [Size-1:0] nA;
  wire[Size-1:0] fA;

  not(nA,A);
  
  mux21 #(Size) mod (.y(fA),.s(mode),.a1(nA),.a0(A));
  
  assign c[0] = Cin;
  genvar i;
  generate 
    for(i=0 ; i<Size ; i=i+1) 
      begin: row
        add_1bit add1b (.fA(fA[i]),.A(A[i]),.B(B[i]),.Cin(c[i]),.S(S[i]),.Cout(c[i+1]));
    end
  endgenerate
  assign Cout = c[Size];
endmodule
/********************************************************************************/