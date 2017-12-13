module execute(
    // global
    clk, rst,
    // ID
    v_i, stall_o,
    src_i, dest_i,
    wb_i,
    rd_num_i,
    dopc_i,
    opc_i,
    origaddr_i,
    // Register file
    wb_o,
    rd_num_o,
    rd_data_o
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
//`include "ex/modules/branch_mod.v"
`define W_DATA (`WORD + `W_STATUS)

    // global
    input clk, rst;
    // ID
    input v_i;
    output stall_o;
    input [`WORD -1:0] src_i, dest_i;
    input wb_i;
    input [`W_RD - 1:0] rd_num_i;
    input [`W_DOPC - 1:0] dopc_i;
    input [`W_OPC - 1:0] opc_i;
    input [`ADDR - 1:0] origaddr_i;
    // Register file
    output wb_o;
    output [`W_RD - 1:0] rd_num_o;
    output [`WORD - 1:0] rd_data_o;

    // pipeline registers
    reg v_r;
    reg wb_r;
    reg [`W_RD - 1:0] rd_num_r;
    reg [`WORD - 1:0] rd_data_r;

    // internal register
    reg [`W_STATUS - 1:0] status_r;

    // connecting registers to output
    assign v_o = v_r;
    assign stall_o = 1'b0; //TODO
    assign wb_o = wb_r;
    assign rd_num_o = rd_num_r;
    assign rd_data_o = rd_data_r;

    wire addsub = dopc_i[`W_DOPC - 1];
    wire mul    = dopc_i[`W_DOPC - 2];
    wire div    = dopc_i[`W_DOPC - 3];
    wire abs    = dopc_i[`W_DOPC - 4];
    wire shift  = dopc_i[`W_DOPC - 5];
    wire logic  = dopc_i[`W_DOPC - 6];
    wire set    = dopc_i[`W_DOPC - 7];
    wire load   = dopc_i[`W_DOPC - 8];
    wire store  = dopc_i[`W_DOPC - 9];
    wire branch = dopc_i[`W_DOPC - 10];
    wire nop    = dopc_i[`W_DOPC - 11];
    wire halt   = dopc_i[`W_DOPC - 12];

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
//    branch_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));

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
    wire [`WORD - 1:0] rd_data = actual_data[`W_DATA - 1:`W_STATUS];
    wire [`W_STATUS - 1:0] status = actual_data[`W_STATUS - 1:0];

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
            wb_r <= 0;
            rd_num_r <= 0;
            rd_data_r <= 0;
            status_r <= 0;
        end
        else begin // no stall because this is the last stage
            v_r <= v;
            wb_r <= wb;
            rd_num_r <= rd_num_i;
            rd_data_r <= rd_data;
            status_r <= status;
        end
    end
endmodule

