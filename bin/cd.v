module cd(input wire clk, reset, s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, input wire [2:0] op_alu, output wire s_z, s_n, output wire [5:0] opcode);
//Camino de datos de instrucciones de un solo ciclo
    wire [15:0] instruccion;

    // Program counter
    wire [9:0] e_pc, s_pc, s_mux_pc;

    registro#(10) pc(clk, reset, 1'b1, e_pc, s_pc);

    // Pila
    wire [9:0] s_pila, s_sumador_pc;

    pila stack(clk, reset, wesp, push, pop, s_sumador_pc, s_pila);

    // Calculo de la entrada del pc
    sum sumador(s_pc, 10'b1, s_sumador_pc);

    mux2#(10) mux_sum_pal (instruccion[9:0], s_sumador_pc, s_inc, s_mux_pc);
    
    // Para conectar el registro PC con la pila
    mux2#(10) mux_pc_stack (s_mux_pc, s_pila, pop, e_pc);

    // Memoria de programa
    memprog memoria_programa(clk, s_pc, instruccion);

    // Banco de registros
    wire [7:0] wd3, rd1, rd2;

    regfile banco_registros (clk, we3, instruccion[11:8], instruccion[7:4], instruccion[3:0], wd3, rd1, rd2);

    // Calculo de dato a escribir (wd3)
    wire [7:0] s_alu;

    mux2 mux_wd3 (s_alu, instruccion[11:4], s_inm, wd3);

    // ALU
    wire zalu, carry, nalu;

    alu uni_art_log(rd1, rd2, op_alu, bp, carry, s_alu, nalu, zalu);

    // FFZ
    ffd ffz(clk, reset, zalu, wez, s_z);

    // FFN
    ffd ffn(clk, reset, nalu, wen, s_n);

    assign opcode = instruccion[15:10];

endmodule
