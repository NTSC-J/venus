#!/usr/bin/perl

use strict;
use warnings;

print << "EOS";
module g_register(clk, rst,
                  w_reserve_i,
                  r0_num_i, r1_num_i,
                  r0_data_o, r1_data_o,
                  reserved_o,
                  wb_i, wbr_num_i, wb_data_i);
`include "include/params.vh"

    input clk, rst;
    input w_reserve_i;
    input [W_RD - 1:0] r0_num_i, r1_num_i;
    output [WORD - 1:0] r0_data_o, r1_data_0;
    output reserved_o;

    input wb_i;
    input [W_RD - 1:0] wbr_num_i;
    input [WORD - 1:0] wb_data_i;

    wire [REG_S - 1:0] w_reserve;
    wire [REG_S - 1:0] w_reserved;
    wire [REG_S - 1:0] wb_r;

EOS
for (my $i = 0; $i < 16; $i++) {
    printf("    wire [WORD - 1:0] data%x;\n", $i);
}
print << "EOS";

`include "util/select16.v"

EOS
for (my $i = 0; $i < 2; $i++) {
    printf("    assign r%d_data_o = select16(r%d_num_i,\n", $i, $i);
    for (my $j = 0; $j < 15; $j++) {
        printf("data%x, ", $j);
    }
    printf("dataf);\n");
}

