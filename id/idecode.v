module idecode(clk, rst,
            v_i, v_o,
            inst_i,
            imm_o,
            stall_i, stall_o);

`include "include/params.vh"

    input clk, rst;
    input v_i;
    output v_o;
    input [WORD - 1:0] inst_i;
    output [WORD - 1:0] imm_o;
    input stall_i;
    output stall_o;

    // pipeline registers
    reg v_r;

    // connecting registers to output
    assign v_o = v_r;
    assign stall_o = (v_r & stall_i);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
        end
        else begin
            if (~stall_i) begin
                v_r <= v_i;
            end
        end
    end
endmodule

