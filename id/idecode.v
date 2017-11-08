module idecode(clk, rst,
            v_i, v_o,
            inst_i,
            src_o, dest_o,
            dopc_o,
            stall_i, stall_o);

`include "include/params.vh"
`include "id/decode_ope.v"
`include "id/expand_imm.v"

    input clk, rst;
    input v_i;
    output v_o;
    input [WORD - 1:0] inst_i; // instruction
    output [WORD - 1:0] src_o, dest_o;
    output [W_RD - 1:0] rdnum_o; // the register No. to wb the result
    output wb_o; // whether wb is required
    output [W_DOPC - 1:0] dopc_o; // decoded opecode
    input stall_i;
    output stall_o;

    // pipeline registers
    reg v_r;
    reg [WORD - 1:0] src_r, dest_r;
    reg [W_DOPC - 1:0] dopc_r;

    // connecting registers to output
    assign v_o = v_r;
    assign stall_o = (v_r & stall_i);
    assign src_o = src_r;
    assign dest_o = dest_r;
    assign dopc_o = dopc_r;

    // decoding the instruction
    wire [W_OPC - 1:0] opecode = inst_i[OPC_MSB:OPC_LSB];
    wire immf = inst_i[IMMF_BIT];
    wire [W_RD - 1:0] rd_num = inst_i[RD_MSB:RD_LSB];
    wire [W_RS - 1:0] rs_num = inst_i[RS_MSB:RS_LSB];
    wire [W_IMM - 1:0] imm = inst_i[IMM_MSB:IMM_LSB];

    wire [W_DOPC - 1:0] dopc = decode_ope(opecode);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
        end
        else begin
            if (~stall_i) begin
                v_r <= v_i;
                if (immf)
                    src_r <= expand_imm(opecode, imm);
                else
                    src_r <= regi(rs_num);

                dest_r <= regi(rd_num);
                dopc_r <= dopc;
            end
        end
    end
endmodule

