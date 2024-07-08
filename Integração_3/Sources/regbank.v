/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module:	registers bank with Size bits
 	Filename: regbank.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
		Gabriel Dezejácomo Maruschi(14571525)
		Matheus Cavalcanti de Santana(13217506)
		Vitor Pardini Saconi(14611800)
		Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/
 

module regbank #(parameter Size=8,  //número de bits dos dados
                       parameter nreg=4)( //número de registradores
  output reg [Size-1:0] rd1,rd2, //saídas 1 e 2 de dados dos registradores
  input [1:0] a1,a2, //endereços dos registradores a serem lidos em rd1 e rd2 respectivamente
  input clk,clr_n, //clock e reset respectivamente
  input [Size-1:0] wd, //dado a ser armazenado por um dos registradores
  input we //ativamento de armazenamento no banco
);
  wire [nreg-1:0] en;
  reg [Size-1:0] q [nreg-1:0];
  
  decode24 selec_write (.en(we),.A(a1[1]),.B(a1[0]),.Y(en));
  
  genvar i;
  generate
    for(i=0;i<nreg;i=i+1) 
      begin: row
        register#(Size) register_8 (.Q(q[i]), .clk(clk), .clr_n(clr_n), .D(wd), .en(en[i]) );
      end
    endgenerate
   mux41#(Size) m1 ( .y(rd1) , .s(a1), .a3(q[3]), .a2(q[2]), .a1(q[1]), .a0(q[0]) );
   mux41#(Size) m2 ( .y(rd2) , .s(a2), .a3(q[3]), .a2(q[2]), .a1(q[1]), .a0(q[0]) );
 endmodule
/********************************************************************************/

