module top_tb ();
//entradas del sistema
    reg clk = 0;
    reg M = 0;
    reg I = 0;
//
    reg [3:0] B = 0;
    reg L = 0;
//
    reg Q = 0;

//Salidas del sistema
    wire [3:0] S_g; //Estado máquina grande
    wire [2:0] U;
    wire [3:0] R;
    wire FC; ////easter egg de cuando has completado 1 vuelta al 100%

//Salidas secuencia de sec_inicio
    wire E;
    wire [1:0] S_i;

//Salidas modo secreto_5
    wire P;
    wire [1:0] S_5;

//clock
    always
    #1 clk = ~clk;
    //Máquinas
    inicio T0(clk, Q, E, S_i);
    secreto_5 T1(clk, L, B, P, S_5);
    FSM T2(clk, M, E, P, I, S_g, U, R, FC);

//Pruebas
//Sólo se puede modificar M, I, Q, L, B
//Contraseña inicio: 1101;  Código modos secretos,
    initial begin
        $display("E\t P\t M\t I\t L\t Q\t | B\t | S_g\t | S_i\t  | S_5\t    |  U\t    R\t    FC\t");
        $monitor("%b\t %b\t %b\t %b\t %b\t %d\t | %d\t | %d\t | %d\t  |  %d\t    | %d\t           %d\t     %d\t",E,P,M,I,L,Q,B,S_g,S_i,S_5,U,R,FC);
        #1 M = 0; I = 0; Q = 0; L = 0; B = 0; //CONDICIONES INCIALES
        #2 M = 1; Q = 1; I = 1; B = 1;          //METEMOS LA CONTRAEÑA PARA INICIAR LA MÁQUINA
        #2 Q = 1; B = 3;
        #2 Q = 0; B = 15;           //INGRESAMOS EL CÓDIGO B=1, B= 3, B= 15 PARA ACCEDER A LOS ESTADOS SECRETOS, Ahora solo activamos L para poder entrar
        #2 Q = 1;                 //lA MÁQUINA INICIA EN EL ESTADO 1
        #2 Q = 0; M = 0; I = 0;                //acá insertamos la secuencia de prueba de la máquina grande
        #2  M = 0; I = 1;                     //Presionamos I para activar la salida del modo 1
        #2  M = 1; I = 0;                     //La secuencia continúa como en la fase de prueba
        #2  M = 0; I = 1;
        #2  M = 1; I = 0;
        #2  M = 0; I = 1;
        #2  M = 1; I = 0;
        #2  M = 0; I = 1;
        #2  M = 1; I = 0;
        #2  M = 0; I = 1;
        #2  M = 1; I = 0;
        #2  M = 0; I = 1;           //Stage 6
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
        #2  M = 0; I = 1;          //1 Normal cycle
        #2  M = 1; I = 0;
        #2  M = 0; I = 1; L = 1;  //Stage 2 2nd lap, Activte secret Stage
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
        #2  M = 0; I = 1;         //Full complete cycle easter egg
        #2  M = 1; I = 0;
        #2  M = 0; I = 1;


        $finish;
    end

//GTKWAVE
/*
    initial begin
      $dumpfile("top_tb.vcd");
      $dumpvars(0, T2);
      $dumpvars(0, T1);
      $dumpvars(0, T0);
    end
*/
endmodule // top_tb
