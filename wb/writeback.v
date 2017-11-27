module writeback(
    // global
    clk, rst,
    // EX
    v_i, stall_o,
    wb_i,
    rd_num_i,
    rd_data_i,
    // register file
    wb_o,
    wbr_num_o,
    wb_data_o
);
`include "include/params.vh"
    input clk, rst;

    input v_i;
    output stall_o;
    input wb_i;
    input [`W_RD - 1:0] rd_num_i;
    input [`WORD - 1:0] rd_data_i;
    
    output wb_o;
    output [`W_RD - 1:0] wbr_num_o;
    output [`WORD - 1:0] wb_data_o;

    assign stall_o = 1'b0;

    assign wb_o = v_i & wb_i;
    assign wbr_num_o = {`W_RD{v_i}} & rd_num_i;
    assign wb_data_o = {`WORD{v_i}} & rd_data_i;

endmodule

