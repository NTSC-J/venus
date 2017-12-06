module idecode(
    // global
    clk, rst,
    // IF
    v_i, stall_o,
    inst_i,             // instruction
    origaddr_i,         // addr of the instruction
    // EX
    src_o, dest_o,      // read register/imm data
    wb_o,               // whether writeback is required
    rd_num_o,           // register number of rd (used in WB stage)
    dopc_o,             // decoded opecode
    opc_o,              // raw opecode
    origaddr_o,
    stall_i, v_o,
    // register file
    w_reserve_o,
    r0_num_o, r1_num_o,
    r0_data_i, r1_data_i,
    reserved_i
);

`include "include/params.vh"
`include "id/decode_ope.v"
`include "id/expand_imm.v"
`include "id/wb_required.v"

    // global
    input clk, rst;
    // IF
    input v_i;
    output stall_o;
    input [`WORD - 1:0] inst_i;
    input [`ADDR - 1:0] origaddr_i;
    // EX
    output [`WORD - 1:0] src_o, dest_o;
    output wb_o;
    output [`W_RD - 1:0] rd_num_o;
    output [`W_DOPC - 1:0] dopc_o;
    output [`W_OPC - 1:0] opc_o;
    output [`ADDR - 1:0] origaddr_o;
    output v_o;
    input stall_i;
    // register file
    output w_reserve_o;
    output [`W_RD - 1:0] r0_num_o;
    output [`W_RS - 1:0] r1_num_o;
    input [`WORD - 1:0] r0_data_i, r1_data_i;
    input reserved_i;

    // pipeline registers
    reg v_r;
    reg [`WORD - 1:0] src_r, dest_r;
    reg [`W_DOPC - 1:0] dopc_r;
    reg [`W_OPC - 1:0] opc_r;
    reg [`ADDR - 1:0] origaddr_r;
    reg wb_r;
    reg [`W_RD - 1:0] rd_num_r;

    // connecting registers to output
    assign v_o = v_r;
    //assign stall_o = (v_r & stall_i) | reserved_i; // TODO: when using imm
    assign stall_o = (v_r & stall_i);
    assign src_o = src_r;
    assign dest_o = dest_r;
    assign dopc_o = dopc_r;
    assign opc_o = opc_r;
    assign origaddr_o = origaddr_r;
    assign wb_o = wb_r;
    assign rd_num_o = rd_num_r;

    // decoding the instruction
    wire [`W_OPC - 1:0] opecode = inst_i[`OPC_MSB:`OPC_LSB];
    wire immf = inst_i[`IMMF_BIT];
    wire [`W_RD - 1:0] rd_num = inst_i[`RD_MSB:`RD_LSB];
    wire [`W_RS - 1:0] rs_num = inst_i[`RS_MSB:`RS_LSB];
    wire [`W_IMM - 1:0] imm = inst_i[`IMM_MSB:`IMM_LSB];

    wire [`W_DOPC - 1:0] dopc = decode_ope(opecode);
    wire wb = wb_required(opecode);

    // connected to RF, without pipeline registers
    assign w_reserve_o = wb; // TODO: redundant?
    assign r0_num_o = rd_num;
    assign r1_num_o = rs_num;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
            src_r <= 0;
            dest_r <= 0;
            dopc_r <= 0;
            opc_r <= 0;
            origaddr_r <= 0;
            wb_r <= 0;
            rd_num_r <= 0;
        end
        else begin
            if (~stall_i) begin
                v_r <= v_i;
                if (immf)
                    src_r <= expand_imm(opecode, imm);
                else
                    src_r <= r1_data_i;

                dest_r <= r0_data_i;
                dopc_r <= dopc;
                opc_r <= opecode;
                origaddr_r <= origaddr_i;
                rd_num_r <= rd_num;
                wb_r <= wb;
            end
        end
    end
endmodule

