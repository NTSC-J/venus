module idecode(clk, rst,
            v_i, v_o,
            inst_i,
            src_o, dest_o,
            immf_o, imms_o, immu_o,
            dopc_o,
            stall_i, stall_o);

`include "include/params.vh"
`include "id/decode_ope.v"

    input clk, rst;
    input v_i;
    output v_o;
    input [WORD - 1:0] inst_i;
    output [WORD - 1:0] src_o;
    output [WORD - 1:0] dest_o;
    output immf_o;
    output [WORD - 1:0] imms_o, immu_o; // signed/unsigned
    output [W_DOPC - 1:0] dopc_o;
    input stall_i;
    output stall_o;

    // pipeline registers
    reg v_r;
    reg immf_r;
    reg [WORD - 1:0] imms_r, immu_r;
    reg [W_DOPC - 1:0] dopc_r;

    // connecting registers to output
    assign v_o = v_r;
    assign stall_o = (v_r & stall_i);
    assign immf_o = immf_r;
    assign imms_o = imms_r;
    assign immu_o = immu_r;
    assign dopc_o = dopc_r;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
        end
        else begin
            if (~stall_i) begin
                v_r <= v_i;
                imms_r <= {16{inst_i[IMM_MSB]}, inst_i[IMM_MSB:IMM_LSB]};
                immu_r <= {16'b0, inst_i[IMM_MSB:IMM_LSB]};
                dopc_r <= decode_ope(inst_i[OPC_MSB:OPC_LSB]);
            end
        end
    end
endmodule

