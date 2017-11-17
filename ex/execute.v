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
    // WB
    stall_i, v_o,
    rd_num_o,
    wb_o,
    rd_data_o
);

`include "include/params.vh"
`include "ex/inte_mod.v"
`include "ex/shift_mod.v"
`include "ex/logic_mod.v"
`include "ex/load_mod.v"
`include "ex/store_mod.v"
`include "ex/branch_mod.v"

    // global
    input clk, rst;
    // ID
    input v_i;
    output stall_o;
    input [WORD -1:0] src_i, dest_i;
    input wb_i;
    input rd_num_i;
    input dopc_i;
    input opc_i;
    input origaddr_i;
    // WB
    input stall_i;
    output v_o;
    output [W_RD - 1:0] rd_num_o;
    output wb_o;
    output [WORD - 1:0] rd_data_o;

    // pipeline registers
    reg v_r;
    reg [W_RD - 1:0] rd_num_r;
    reg wb_r;
    reg [WORD - 1:0] rd_data_r;

    // internal register
    reg [W_FLAGS - 1:0] flags;

    // connecting registers to output
    assign v_o = v_r;
    assign stall_o = (v_r & stall_i);
    assign rd_num_o = rd_num_r;
    assign wb_o = wb_r;
    assign rd_data_o = rd_data_r;

    assign inte   = dopc[W_DOPC - 1];
    assign shift  = dopc[W_DOPC - 2];
    assign logic  = dopc[W_DOPC - 3];
    assign load   = dopc[W_DOPC - 4];
    assign store  = dopc[W_DOPC - 5];
    assign branch = dopc[W_DOPC - 6];

    // data: {rd,flags}
    assign inte_data = inte_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    assign shift_data = shift_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    assign logic_data = logic_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    assign load_data = load_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    store_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));
    branch_mod(.opc_i(opc_i), .src_i(src_i), .dest_i(dest_i));

    assign actual_data =
        ({(WORD + W_FLAGS){inte}} & inte_data) |
        ({(WORD + W_FLAGS){shift}} & shift_data) |
        ({(WORD + W_FLAGS){logic}} & logic_data) |
        ({(WORD + W_FLAGS){load}} & load_data);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
            rd_num_r <= 0;
            wb_r <= 0;
            rd_data_r <= 0;
            flags <= 0;
        end
        else begin
            if (~stall_i) begin
                v_r <= v_i;
                rd_num_r <= rd_num_i;
                wb_r <= wb_i;
                rd_data_r <= actual_data[WORD + W_FLAGS - 1:W_FLAGS];
                flags <= actual_data[W_FLAGS - 1:0];
            end
        end
    end
endmodule

