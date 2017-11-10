#!/usr/bin/perl

use strict;
use warnings;

print << "EOS";
// register file
// connected to ID, WB stage
module g_register(
    // global
    clk, rst,
    // ID
    w_reserve_i,          // request to w-reserve r0
    r0_num_i, r1_num_i,   // register number
    r0_data_o, r1_data_o, // data output
    reserved_o,           // requested register is reserved
    // WB
    wb_i,                 // request writeback
    wbr_num_i,            // register number
    wb_data_i             // data input
);
`include "include/params.vh"
`include "util/select16.v"
`include "util/decode16.v"

    input clk, rst;

    input w_reserve_i;
    input [W_RD - 1:0] r0_num_i, r1_num_i;
    output [WORD - 1:0] r0_data_o, r1_data_0;
    output reserved_o;

    input wb_i;
    input [W_RD - 1:0] wbr_num_i;
    input [WORD - 1:0] wb_data_i;

EOS
printf("    wire [WORD - 1:0] ");
for (my $i = 0; $i < 15; $i++) {
    printf("data%x, ", $i);
}
printf("dataf;\n");
for (my $i = 0; $i < 2; $i++) {
    printf("    assign r%d_data_o = select16(r%d_num_i,\n", $i, $i);
    for (my $j = 0; $j < 15; $j++) {
        printf("data%x, ", $j);
    }
    printf("dataf);\n");
}
print << "EOS";

    wire [REG_S - 1:0] w_reserved;
    wire [REG_S - 1:0] w_reserve = decode16(r0_num_i) & {16{w_reserve_i}};
    assign reserved_o = |((decode16(r0_num_i) | decode16(r1_num_i)) & w_reserved);
    wire [REG_S - 1:0] wb_r = decode16(wbr_num_i) & {16{wb_i}};

EOS
for (my $i = 0; $i < 16; $i++) {
    printf("    register_cell r%1\$x(\n".
           "        .clk(clk), .rst(rst),\n".
           "        .data_i(wb_data_i),\n".
           "        .data_o(data%1\$x),\n".
           "        .w_reserve_i(w_reserve[%1\$d]),\n".
           "        .w_reserve_o(w_reserved[%1\$d]),\n".
           "        .wb_i(wb_r[%1\$d])\n".
           "    );\n", $i);
}

