/* ----- ----- ----- ----- ----- -----
	Design: Parallel register with positive clock transition
			using type D flip-flop
 			for digital circuits
 	Filename: register.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 
`timescale 1 ns/100 ps

module dff(
		output reg Q,
		output Qb,
		input clk,clrn, D,
  		input en
);
  always @ (posedge clk or posedge clrn)begin //transição positiva do clock
    if (clrn)  //após subida e descida do reset, o circuito passa a funcionar sequencialmente
         Q <= 1'b0;
  	else if(en)
         Q <= D;
  end
  assign Qb=~Q;

endmodule

module register #(parameter Size=8)(
  		output reg [Size-1:0] Q,
		input clk, 
		rstn, 
  		input [Size-1:0] D,
  		input en
);

   genvar i;
   generate
     for (i=0; i<Size; i=i+1)
         begin: row
           dff ui (.Q(Q[i]), .Qb(), .clk(clk), .clrn(rstn), .D(D[i]), .en(en));
         end
   endgenerate

endmodule