module execute(
    // global
    clk, rst,
    // IF
    branch_o,
    baddr_o,
    // ID
    v_i, stall_o,
    src_i, dest_i,
    wb_i,
    wb_rd_name_i,
    dopc_i,
    opc_i,
    origaddr_i,
    cc_i,
    // Register file
    wb_o,
    wb_rd_name_o,
    wb_rd_data_o
);

`include "include/params.vh"
`include "ex/modules/addsub_mod.v"
`include "ex/modules/mul_mod.v"
`include "ex/modules/abs_mod.v"
`include "ex/modules/shift_mod.v"
`include "ex/modules/logic_mod.v"
`include "ex/modules/set_mod.v"
//`include "ex/modules/load_mod.v"
//`include "ex/modules/store_mod.v"
`include "ex/modules/jump_mod.v"
`define W_DATA (`WORD + `W_STATUS)

    // global
    input clk, rst;
    // IF
    output branch_o;
    output [`ADDR - 1:0] baddr_o;
    // ID
    input v_i;
    output stall_o;
    input [`WORD -1:0] src_i, dest_i;
    input wb_i;
    input [`W_RD - 1:0] wb_rd_name_i;
    input [`W_DOPC - 1:0] dopc_i;
    input [`W_OPC - 1:0] opc_i;
    input [`ADDR - 1:0] origaddr_i;
    input [`W_CC - 1:0] cc_i;
    // Register file
    output wb_o;
    output [`W_RD - 1:0] wb_rd_name_o;
    output [`WORD - 1:0] wb_rd_data_o;

    // pipeline registers
    reg v_r;
    reg wb_r;
    reg [`W_RD - 1:0] wb_rd_name_r;
    reg [`WORD - 1:0] wb_rd_data_r;
    reg stall_r;

    // internal register
    reg [`W_STATUS - 1:0] status_r;

    wire addsub = dopc_i[`W_DOPC - 1];
    wire mul    = dopc_i[`W_DOPC - 2];
    wire div    = dopc_i[`W_DOPC - 3];
    wire abs    = dopc_i[`W_DOPC - 4];
    wire shift  = dopc_i[`W_DOPC - 5];
    wire logic  = dopc_i[`W_DOPC - 6];
    wire set    = dopc_i[`W_DOPC - 7];
    wire load   = dopc_i[`W_DOPC - 8];
    wire store  = dopc_i[`W_DOPC - 9];
    wire jump   = dopc_i[`W_DOPC - 10];
    wire nop    = dopc_i[`W_DOPC - 11]; // FIXME: unused
    wire halt   = dopc_i[`W_DOPC - 12];

    // connecting registers to output
    assign v_o = v_r;
    assign wb_o = wb_r;
    assign wb_rd_name_o = wb_rd_name_r;
    assign wb_rd_data_o = wb_rd_data_r;
    assign stall_o = stall_r;

    // data: {rd,flags}
    wire [`W_DATA - 1:0] addsub_data =
        addsub_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    wire [`W_DATA - 1:0] mul_data =
        mul_mod(.src_i(src_i), .dest_i(dest_i));
    wire [`W_DATA - 1:0] abs_data =
        abs_mod(.src_i(src_i));
    wire [`W_DATA - 1:0] shift_data =
        shift_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    wire [`W_DATA - 1:0] logic_data =
        logic_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    wire [`W_DATA - 1:0] set_data =
        set_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
//    assign load_data = load_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
//    store_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    wire [`ADDR:0] jump_data =
        jump_mod(.opc_i(opc_i), .cc_i(cc_i), .src_i(src_i), .origaddr_i(origaddr_i), .status_i(status_r));
    assign branch_o = jump & jump_data[`ADDR];
    assign baddr_o = jump_data[`ADDR - 1:0];

    wire [`W_DATA - 1:0] actual_data =
        ({`W_DATA{addsub}} & addsub_data) |
        ({`W_DATA{mul}} & mul_data) |
        // div
        ({`W_DATA{shift}} & shift_data) |
        ({`W_DATA{logic}} & logic_data) |
        ({`W_DATA{set}} & set_data);
        // load, store
    wire v = v_i; // TODO
    wire wb = v & wb_i;
    wire [`WORD - 1:0] wb_rd_data = actual_data[`W_DATA - 1:`W_STATUS];
    wire [`W_STATUS - 1:0] status = actual_data[`W_STATUS - 1:0];

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
            wb_r <= 0;
            wb_rd_name_r <= 0;
            wb_rd_data_r <= 0;
            status_r <= 0;
            stall_r <= 0;
        end
        else begin // no stall because this is the last stage
            v_r <= v;
            wb_r <= wb;
            wb_rd_name_r <= wb_rd_name_i;
            wb_rd_data_r <= wb_rd_data;
            status_r <= status;
            if (halt)
                stall_r <= 1'b1;
        end
    end
endmodule

