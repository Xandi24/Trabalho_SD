// Code your design here

/* ----- ----- ----- ----- ----- -----
	Design:	file for test in EDAplayground
 	Filename: design.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
		Gabriel Dezejácomo Maruschi(14571525)
		Matheus Cavalcanti de Santana(13217506)
		Vitor Pardini Saconi(14611800)
		Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /july_2024/
	----- ----- ----- ----- ----- -----
*/
/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module: 2x1 Multiplexer
			By using conditional descripition
 			for digital circuits
 	Filename: mux21.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 

module mux21 
  #(parameter Size=8)
  (output[Size-1:0]y, input s, input [Size-1:0] a1, a0);
	assign y= s? a1:a0;
endmodule
/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module: 4x1 Multiplexer
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
/********************************************************************************/


/* ----- ----- ----- ----- ----- -----
	Module: 2x4 Decoder
			By using primitives
 			for digital circuits
 	Filename: decode24.v
	Coder: Vitor Alexandre Garcia Vaz(14611432)
 	Versions: /june_2024/
	----- ----- ----- ----- ----- -----
*/ 

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


/* ----- ----- ----- ----- ----- -----
	Module:	ALU ( Arithmetic-Logic Unit)
 	Filename: ALU.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
			Gabriel DezejÃ¡como Maruschi(14571525)
			Matheus Cavalcanti de Santana(13217506)
			Vitor Pardini Saconi(14611800)
			Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /july_2024/
	----- ----- ----- ----- ----- -----
*/

module ALU #(parameter Size=8)(
  input [Size-1:0] A,B,
  input [1:0] funct,
  output [Size-1:0] ALUOut,
  output zero
);
  wire [Size-1:0] a [3:0];
  
  
  adder #(Size) som (.mode(funct[0]), .A(A), .B(B), .Cin(0), .Cout(), .S(a[0]) );
  adder #(Size) sub (.mode(funct[1]), .A(A), .B(B), .Cin(0), .Cout(), .S(a[1]) );
  
  and (a[2],A,B);
  or(a[3],A,B);
  
  mux41 #(Size) select ( .y(ALUOut), .s(funct), .a3(a[3]), .a2(a[2]), .a1(a[1]), .a0(a[0]) );
  
  assign zero = ALUOut? 0:1;
  
endmodule
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


/* ----- ----- ----- ----- ----- -----
	Module:	third integration
 	Filename: uP_SEL0628_2024.v
	Coders: Vitor Alexandre Garcia Vaz(14611432)
    		Pedro Gasparelo Leme(14602421)
		Gabriel Dezejácomo Maruschi(14571525)
		Matheus Cavalcanti de Santana(13217506)
		Vitor Pardini Saconi(14611800)
		Santhiago Aguiar Afonso da Rosa(14607274)
 	Versions: /july_2024/
	----- ----- ----- ----- ----- -----
*/

module uP_SEL0628_2024 (
	input clk, clr_n,
	input [7:0] data_in,
	output we,
	output [5:0] addr,
	output [7:0] data_out
);

	wire PC_en, PC_ld, LdSt, IR_en, Wb, RF_we, Zero;
	wire [1:0] a1, a2, ALU_Control;
	wire [5:0] PC_out;
	wire [7:0] IR_out, ALUOut, wd, rd1, rd2;

  	counter #(6) PC (.clk(clk), .clr_n(clr_n), .en(PC_en), .ld(PC_ld), .D(IR_out[5:0]), .Q(PC_out));
	
  	mux21 #(6) MEM_ADR (.s(LdSt), .a0(PC_out), .a1(IR_out[5:0]), .y(addr));
	
	register #(8) IR (.clk(clk), .clr_n(clr_n), .en(IR_en), .D(data_in), .Q(IR_out));
	
	fsm UC (.clk(clk), .clr_n(clr_n), .instr(IR_out), .Zero(Zero), .PC_en(PC_en) ,.PC_ld(PC_ld), .LdSt(LdSt), .we(we), .IR_en(IR_en), .Wb(Wb), .RF_en(RF_we), .A1(a1), .A2(a2), .ALU_Control(ALU_Control));
	
  	regbank #(.Size(8), .nreg(4)) REGFILE (.clk(clk), .clr_n(clr_n), .we(RF_we), .a1(a1), .a2(a2), .wd(wd), .rd1(rd1), .rd2(rd2));
	
	ALU #(8) ula (.funct(ALU_Control), .A(rd1), .B(rd2), .ALUOut(ALUOut), .zero(Zero));

	mux21 #(8) WR_BCK (.s(Wb), .a0(ALUOut), .a1(data_in), .y(wd));
	
	assign data_out = rd2;
	
endmodule
/********************************************************************************/  



  
  
  

