module test_if_top(clk, rst, v_i, stall_i, branch_i, baddr_i);

`include "include/params.vh"

    input clk, rst;
    input v_i, stall_i;
    input branch_i;
    input [`ADDR - 1:0] baddr_i;

    wire [`ADDR - 1:0] addr;
    wire [`WORD - 1:0] inst_mem, inst_f;
    ifetch ifetch1(
        .clk(clk), .rst(rst),
        .inst_i(inst_mem), .inst_o(inst_f),
        .branch_i(branch_i), .baddr_i(baddr_i), .addr_o(addr),
        .stall_i(stall_i));

    DP_mem32x64k mem(
        .clk(clk), .A(addr), .W(1'b0), .D(), .Q(inst_mem));
endmodule

