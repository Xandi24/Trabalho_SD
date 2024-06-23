/* ----- ----- ----- ----- ----- -----
	Design:	Banco registradores de Size bits
 	Filename: bregisters.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
			Gabriel DezejÃ¡como Maruschi(14571525)
			Matheus Cavalcanti de Santana(13217506)
			Vitor Pardini Saconi(14611800)
			Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/
 
`timescale 1 ns/100 ps

//--------------------------- PARTE 4 EM SI -------------------------------------//

module bregisters #(parameter Size=8,  // Número de bits dos dados
                       parameter nreg=4)( // Número de registradores
  output reg [Size-1:0] rd1,rd2, // Saídas 1 e 2 de dados dos registradores
  input [1:0] a1,a2, // Endereços dos registradores a serem lidos em rd1 e rd2 respectivamente
  input clk,clk_n, // Clock e reset respectivamente
  input [Size-1:0] wd, // Dado (de Size bits) a ser armazenado por um dos registradores
  input we // Ativamento de armazenamento no banco
);
  wire [nreg-1:0] en; // Cria fios de enables, os quais transmitirão a saída do decodificador que seleciona
  					  //qual registrador (0,1,2 ou 3) deve escrever um dado (armazená-lo)
  reg [Size-1:0] q [nreg-1:0]; // Fios de saída de dados dos registradores, sendo que o mux deve selecionar
  							   //um dos 4 fios (q) para leitura de dado
  
  decode24 selec_write (.en(we),.A(a1[1]),.B(a1[0]),.Y(en));
  
  genvar i;
  generate
    for(i=0;i<nreg;i=i+1) 
      begin: row
        register#(Size) register_8 (.Q(q[i]), .clk(clk), .rstn(clk_n), .D(wd), .en(en[i]) );
      end
    endgenerate
   mux41#(Size) m1 ( .y(rd1) , .s(a1), .a3(q[3]), .a2(q[2]), .a1(q[1]), .a0(q[0]) );
   mux41#(Size) m2 ( .y(rd2) , .s(a2), .a3(q[3]), .a2(q[2]), .a1(q[1]), .a0(q[0]) );
 endmodule