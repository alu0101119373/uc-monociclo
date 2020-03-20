module uc(input wire clk, input wire [5:0] opcode, input wire s_z, s_n, output reg s_inc, s_inm, we3, wez, wen, wesp, bp, push, pop, output reg [2:0] op_alu);

    // Flag interno para el skip
    reg skip, cont;

    initial
    begin
        skip <= 1'b0;
        cont = 0;
        // Por defecto, las operaciones se realizaran en C2
        bp = 1'b1;
    end

    always @(posedge clk)
    begin
        if (skip)
        begin
            if (cont == 2)
            begin
                skip <= 1'b0;
                cont = 0;
            end
        end
    end

    always @(*)
    begin
        if (skip == 1'b1)
        begin
            s_inc <= 1'b1;
            s_inm <= 1'b0;
            we3 <= 1'b0;
            wez <= 1'b0;
            wen <= 1'b0;
            wesp <= 1'b0;
            push <= 1'b0;
            pop <= 1'b0;
            cont = cont + 1;
        end
        else
        begin
            if (opcode[5:4] == 2'b11)
            begin
                // 6 bits (saltos)
                case (opcode)
		    // J
                    6'b110000:
                    begin
                        s_inc <= 1'b0;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b0;
                        push <= 1'b0;
                        pop <= 1'b0;
                    end
		    // JZ
                    6'b110001:
                    begin
                        if (s_z == 1'b1)
                            s_inc <= 1'b0;
                        else
                            s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b0;
                        push <= 1'b0;
                        pop <= 1'b0;
                    end
		    // JNZ
                    6'b110010:
                    begin
                        if (s_z == 1'b0)
                            s_inc <= 1'b0;
                        else
                            s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b0;
                        push <= 1'b0;
                        pop <= 1'b0;
                    end
                    // JN
                    6'b110011:
                    begin
                        if (s_n == 1'b1)
                            s_inc <= 1'b0;
                        else
                            s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b0;
                        push <= 1'b0;
                        pop <= 1'b0;
                    end
		    // PUSH
                    6'b110100:
                    begin
                        s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b1;
                        pop <= 1'b0;
                        push <= 1'b1;
                    end
		    // POP
                    6'b110101:
                    begin
                        s_inc <= 1'b0;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b1;
                        pop <= 1'b1;
                        push <= 1'b0;
                    end
		    // SKZ
                    6'b110110:
                    begin
                        s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b0;
                        pop <= 1'b0;
                        push <= 1'b0;
                        if (s_z == 1'b1)
                            skip <= 1'b1;
                    end
		    // SKNZ
                    6'b110111:
                    begin
                        s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b0;
                        pop <= 1'b0;
                        push <= 1'b0;
                        if (s_z != 1'b1)
                            skip <= 1'b1;
                    end
                    default:
                    begin
                        s_inc <= 1'b1;
                        s_inm <= 1'b0;
                        we3 <= 1'b0;
                        wez <= 1'b0;
                        wen <= 1'b0;
                        wesp <= 1'b0;
                        push <= 1'b0;
                        pop <= 1'b0;
                    end
                endcase
            end
            else
            begin
                // 4 bits
                if (opcode[5] == 1'b0)
                begin
                    // ALU
                    s_inc <= 1'b1;
                    s_inm <= 1'b0;
                    we3 <= 1'b1;
                    wez <= 1'b1;
                    wen <= 1'b1;
                    wesp <= 1'b0;
                    push <= 1'b0;
                    pop <= 1'b0;
                    op_alu <= opcode[4:2];
                end
                else
                begin
                    // Carga
                    wesp <= 1'b0;
                    push <= 1'b0;
                    pop <= 1'b0;
                    case (opcode[5:2])
                        4'b1000:
                        begin
                            s_inc <= 1'b1;
                            s_inm <= 1'b1;
                            we3 <= 1'b1;
                            wez <= 1'b0;
                            wen <= 1'b0;
                        end
                        default:
                        begin
                            s_inc <= 1'b1;
                            s_inm <= 1'b1;
                            we3 <= 1'b1;
                            wez <= 1'b0;
                            wen <= 1'b0;
                        end
                    endcase
                end
            end
        end
    end
endmodule
