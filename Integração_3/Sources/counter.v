/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module: Counter with positive clock transition and negative reset
			using conditionals (if // else)
 			for digital circuits
 	Filename: counter.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 

module counter #(parameter Size=8) (
  input clk, //clock
  input clr_n, //reset
  input en, //enable
  input ld, //parallel load
  input [Size-1:0] D, //dado de entrada para carga paralela
  output reg [Size-1:0] Q //saída do contador
);
  always @(posedge clk or negedge clr_n) begin
    if(!clr_n) begin
      Q<=0; //com o reset negativo, contagem começa do zero
    end
    else if(ld) begin
      Q<=D; //se não, se ld está ativado, recebe-se a carga paralela
    end
    else if(en) begin
      Q<=Q+1; // se não, se está ativado, incrementa-se a saída
    end
  end
endmodule
/********************************************************************************/