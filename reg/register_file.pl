#!/usr/bin/perl

use strict;
use warnings;

print << "EOS";
// register file
// connected to ID, WB stage
module register_file(
    // global
    clk, rst,
    // ID
    rd_reserve_i,                   // request to w-reserve rd
    rd_name_i, rs_name_i,           // register name
    rd_data_o, rs_data_o,           // data output
    rd_reserved_o, rs_reserved_o,   // requested register is reserved
    // EX
    wb_i,                           // request writeback
    wb_rd_name_i,                   // register name
    wb_rd_data_i                    // data input
);
`include "include/params.vh"
`include "util/select16.v"
`include "util/decode16.v"

    input clk, rst;

    input rd_reserve_i;
    input [`W_RD - 1:0] rd_name_i, rs_name_i;
    output [`WORD - 1:0] rd_data_o, rs_data_o;
    output rd_reserved_o;
    output rs_reserved_o;

    input wb_i;
    input [`W_RD - 1:0] wb_rd_name_i;
    input [`WORD - 1:0] wb_rd_data_i;

EOS
printf("    wire [`WORD - 1:0] ");
for (my $i = 0; $i < 15; $i++) {
    printf("data%x, ", $i);
}
printf("dataf;\n");

printf("    assign rd_data_o = select16(rd_name_i,\n");
for (my $i = 0; $i < 15; $i++) {
    printf("data%x, ", $i);
}
printf("dataf);\n");
printf("    assign rs_data_o = select16(rs_name_i,\n");
for (my $i = 0; $i < 15; $i++) {
    printf("data%x, ", $i);
}
printf("dataf);\n");

print << "EOS";
    wire [`REG_S - 1:0] w_reserved;
    wire [`REG_S - 1:0] w_reserve = decode16(rd_name_i) & {`REG_S{rd_reserve_i}};
    wire [`REG_S - 1:0] wb_r = decode16(wb_rd_name_i) & {16{wb_i}};
    assign rd_reserved_o = |(decode16(rd_name_i) & w_reserved);
    assign rs_reserved_o = |(decode16(rs_name_i) & w_reserved);

EOS
for (my $i = 0; $i < 16; $i++) {
    printf("    register_cell r%1\$x(\n".
           "        .clk(clk), .rst(rst),\n".
           "        .data_i(wb_rd_data_i),\n".
           "        .data_o(data%1\$x),\n".
           "        .w_reserve_i(w_reserve[%1\$d]),\n".
           "        .w_reserved_o(w_reserved[%1\$d]),\n".
           "        .wb_i(wb_r[%1\$d])\n".
           "    );\n", $i);
}
print << "EOS";
endmodule

EOS

