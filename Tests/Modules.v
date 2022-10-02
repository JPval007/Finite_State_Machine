//Módulos y máquinas del sistema
module inicio (input clk, input Q, output E, output [1:0] S);
      reg E = 0;
      reg [1:0] S = 0;  //Comienza en el estado 0

      always @ ( posedge clk) begin
        S[1] <= (S[0] & Q) | (S[1] & (~S[0]) & (~Q) );
        S[0] <= (S[1] & S[0] & Q) | ( (~S[1]) & (~S[0]) & (Q) ) | (S[1] & (~S[0]) & (~Q) );
        E <= (S[1] & S[0] & Q);
        end
endmodule // sec_inicio



//Módulo que maneja la contraseña para el modo secreto con una sola entrada
module secreto (input clk, input L, output P, output [1:0] s);
    reg P =0 ;
    reg [1:0] s = 0;

    always @ ( posedge clk ) begin
      s[1] <= (s[1] & (~s[0]) & L) | ((~s[1]) & (s[0]) & (~L));
      s[0] <= (~s[0]) & L;
      P <= (s[1] & (~s[0]) & (L));
    end
endmodule // secreto



//Módulo que maneja la contraseña para el modo secreto con dos entradas
module secreto_2 (input clk, input L, input B, output P, output [1:0] S);
    reg P =0;
    reg [1:0] S = 0;

    always @ ( posedge clk ) begin
      S[1] <= (S[1] & (~S[0]) & L) | ( (~S[1]) & (S[0]) & (~L) );
      S[0] <= (~S[1]) & (~S[0]) & (L);
      P <= (S[1]) & (~S[0]) & (L) & B;
    end
endmodule // secreto_2

//Módulo de la contraseña con 5 entradas
module secreto_5 (input clk, input L, input [3:0] B, output P, output [1:0] S);
    reg P = 0;  //Salida P
    reg [1:0] S = 0; //Salida del estado

    always @ ( posedge clk ) begin
      S[1] <= (S[1] & (~S[0]) & B[3] & B[2] & B[1] & B[0]) | ( (~S[1]) & (S[0]) & (~B[3]) & (~B[2]) & (B[1]) & (B[0]));
      S[0] <= (~S[1])&(~S[0])&(~B[3])&(~B[2])&( ~B[1])&(B[0]);
      P <= (S[1] & (~S[0]) & L & B[3] &B[2] & B[1] & B[0]);
    end

endmodule // secreto_5

//Módulo que controla todos los estados

module FSM (input clk, input M, input E, input P, input I, output [3:0] S, output [2:0] U, output [3:0] R, output FC);
    reg [3:0] S = 0;
    reg [2:0] U = 0;
    reg [3:0] R = 0;
    reg FC = 0; //el bit de full cycle (overflow)

    always @ ( posedge clk ) begin
      S[3] <= ( (~S[3]) & (S[2]) & (S[0] & S[1]) & M) | (S[3] & (~S[1]) & (~S[0]) ) | ( S[3] & (~M)) | ( S[3] & (~S[2])) | (P & S[3] & (~S[0])) | (P & S[3] & (~S[1]));
      S[2] <= ( (~S[2]) & S[1] & S[0] & M) | (S[2] & (~S[1]) & (~S[0]) ) | (S[2] & (~M) ) | ( (~S[3]) & S[2]) & (~S[0]) | ( P & S[2] & (~S[0]) ) | ( (~S[3]) & S[2] & (~S[1])) | (P & S[2] & (~S[1]));
      S[1] <= ( (~S[1]) & (~S[2]) & (S[0]) & M) | ( (~S[3]) & (~S[1]) & (S[0]) & (M) ) | (P & (~S[1]) & (S[0]) & M ) | ( S[1] & (~M)) | ( (~S[2]) & (S[1]) & (~S[0])) | ( (~S[3]) & (S[1]) & (~S[0])) | (P & S[1] & (~S[0]));
      S[0] <= (E & (~S[3])&(~S[2])&(~S[1])&(~S[0]))|(~P & S[3]&S[2]&M)|(S[3]&S[2]&S[1]&M)|(S[1]&(~S[0])&M)|(S[0]&(~M))|(S[3]&(~S[0])&M)|(S[2]&(~S[0])&M);
//potencia de operación
      U[2] <= (I & (~S[3])& (~S[2])& (~S[1])&S[0])|(I & (~S[3]) & (S[1]) & (~S[0]) )| (I & (S[3]) & (~S[1]) & (~S[0])) | (I & (S[3]) & S[2]) | (I & S[3] & S[1] & S[0]);
      U[1] <= (I & S[2] & (~S[1]) & (~S[0])) | (I & (S[2]) & S[1] & S[0]) | (I & S[3] & (~S[1])) | (I & S[3] & (S[0])) | (I & S[3] & S[2]);
      U[0] <= (I & (~S[3]) & S[1] & S[0]) | (I & S[3] & S[2] & S[1]) | (I & (~S[2]) & S[1] & (~S[0])) | (I & S[3] & (~S[2]) & (~S[1]) & S[0]) | (I & (~S[3]) & S[2] & S[0]);
//tiempo de operación
      R[3] <= (I & (~S[3])& S[1] & (~S[0])) | (I & S[3] & (~S[2]) & (~S[0])) | (I & S[2] & (~S[1])) ;
      R[2] <= (I & (~S[3])& S[1] & (~S[0])) | (I& (~S[1])& S[0]) | (I & S[2] & (~S[1]) ) | (I & (~S[2]) & (S[1]));
      R[1] <= (I & S[3] & S[2] & (~S[1])) | (I & S[3] & (~S[2]) & (~S[0])) | (I & (~S[3]) & S[2] & S[1]) | (I & (~S[3]) & (~S[1]) & (S[0]));
      R[0] <= (I & S[2] & (~S[0]) & (~S[1])) | (I & (~S[2]) & (S[1]) & (S[0])) | (I & S[3] & (~S[0])) | (I & (~S[3]) & (S[0])) ;
      FC <= S[3] & S[2] & S[1] & S[0] & I;
    end

endmodule // FSM

//Prueba secuencia de cambio de modo modo correcto de mostrar los modos
/*
      #1  M = 1; I = 0; P = 1; E = 1;
      #2  I = 1; M = 0; E = 0; P = 0;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0; //#3
      #2  M = 0; I = 1; //LAST
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0; //Full cicle
      #2  M = 0; I = 1; P = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
      #2  M = 1; I = 0;
      #2  M = 0; I = 1; //Full cycle 16 modes
      #2  M = 1; I = 0;
      #2  M = 0; I = 1;
*/
