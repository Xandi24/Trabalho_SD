/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module: Parallel register using type D flip-flop
 			for digital circuits
 	Filename: register.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 

module dff(
		output reg Q,
		output Qb,
		input clk,clr_n, D,
  		input en
);
  always @ (negedge clk or negedge clr_n)begin //transição positiva do clock
    if (~clr_n)  //após subida e descida do reset, o circuito passa a funcionar sequencialmente
         Q <= 1'b0;
  	else if(en)
         Q <= D;
  end
  assign Qb=~Q;

endmodule

module register #(parameter Size=8)(
		input clk, clr_n, en, 
  		input [Size-1:0] D,
  		output reg [Size-1:0] Q
);

   genvar i;
   generate
     for (i=0; i<Size; i=i+1)
         begin: row
           dff ui (.Q(Q[i]), .Qb(), .clk(clk), .clr_n(clr_n), .D(D[i]), .en(en));
         end
   endgenerate

endmodule
/********************************************************************************/

