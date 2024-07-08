/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module:	Finite State Machine
 	Filename: fsm.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
			Gabriel Dezejacomo Maruschi(14571525)
			Matheus Cavalcanti de Santana(13217506)
			Vitor Pardini Saconi(14611800)
			Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /july_2024/
	----- ----- ----- ----- ----- -----
*/
module fsm(
  input clk, clr_n,
  input [7:0] instr,
  input Zero,
  output reg PC_en, PC_ld, LdSt, we, IR_en, Wb, RF_en,
  output reg [1:0] A1, A2, ALU_Control
);
  //Correspondente ao estado atual
  reg [2:0] state; // 3 bits pois temos 6 estados (precisamos de 6 núeros de indicação)

  //Separação das instruções
  wire [1:0] a1, a2, funct, opcode;
  assign opcode=instr[7:6];
  assign funct=instr[5:4];
  assign a2=instr[3:2];
  assign a1=instr[1:0];
  
  //Parametrização dos estados
  parameter LD=3'b000, ST=3'b001, ALU=3'b010, JNZ=3'b011, Fetch=3'b100, Decode=3'b101;
  
  //Inicializando a máquina de estados
  initial begin
    state<=Fetch;
  end
  
  //Próximo estado da máquina
  always @(posedge clk or negedge clr_n) begin
    if(~clr_n) 
    state <= Fetch; //reset coloca no estado padrão de fetch
  else begin
    case(state)
      Fetch: state <= Decode;
      Decode: begin
        case(opcode)
          2'b00: state <= LD;
          2'b01: state <= ST;
          2'b10: state <= ALU;
          2'b11: state <= JNZ;
        endcase
      end
      LD, ST, ALU, JNZ: state <= Fetch;
      default: state <= Decode; // Garantir que sempre temos um estado conhecido
    endcase
  end
end
  
  //Saídas da máquina
  always @(state,Zero,a1,a2,funct) begin
    case(state)
      Fetch: begin
        PC_en<=1'b0; PC_ld<=1'b0; LdSt<=1'b0; we<=1'b0; IR_en<=1'b1; Wb<=1'b0; RF_en<=1'b0;
        A1<=2'b00; A2<=2'b00; ALU_Control<=2'b00;
      end
      Decode: begin
        PC_en<=1'b0; PC_ld<=1'b0; LdSt<=1'b0; we<=1'b0; IR_en<=1'b0; Wb<=1'b0; RF_en<=1'b0;
        A1<=2'b00; A2<=2'b00; ALU_Control<=2'b00;
      end
      LD: begin
        PC_en<=1'b1; PC_ld<=1'b0; LdSt<=1'b1; we<=1'b0; IR_en<=1'b0; Wb<=1'b1; RF_en<=1'b1;
        A1<=2'b00; A2<=2'b00; ALU_Control<=2'b00;
      end
      ST: begin
        PC_en<=1'b1; PC_ld<=1'b0; LdSt<=1'b1; we<=1'b1; IR_en<=1'b0; Wb<=1'b0; RF_en<=1'b0;
        A1<=2'b00; A2<=2'b00; ALU_Control<=2'b00;
      end
      ALU: begin
        PC_en<=1'b1; PC_ld<=1'b0; LdSt<=1'b0; we<=1'b0; IR_en<=1'b0; Wb<=1'b0; RF_en<=1'b1;
        A1<=a1; A2<=a2; ALU_Control<=funct;
      end
      JNZ: begin
        PC_en<=1'b1; 
        if(Zero==1'b1) PC_ld<=1'b1;
        else PC_ld<=1'b0;
        LdSt<=1'b0; we<=1'b0; IR_en<=1'b0; Wb<=1'b0; RF_en<=1'b0;
        A1<=2'b00; A2<=2'b00; ALU_Control<=2'b00;
      end
      default: begin // Segurança, caso ocorra um estado inesperado
        PC_en <= 1'b0; PC_ld <= 1'b0; LdSt <= 1'b0; we <= 1'b0; IR_en <= 1'b0; Wb <= 1'b0; RF_en <= 1'b0;
        A1 <= 2'b00; A2 <= 2'b00; ALU_Control <= 2'b00;
	  end
    endcase
  end
    
endmodule
/********************************************************************************/