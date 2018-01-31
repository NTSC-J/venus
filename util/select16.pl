#!/usr/bin/perl

use strict;
use warnings;

print << 'EOS';
`ifndef _select16_v_
`define _select16_v_

function [`WORD -1: 0] select16;
`include "../include/params.vh"
    input [3: 0] select;

    input [`WORD -1: 0] data0, data1, data2, data3;
    input [`WORD -1: 0] data4, data5, data6, data7;
    input [`WORD -1: 0] data8, data9, dataa, datab;
    input [`WORD -1: 0] datac, datad, datae, dataf;

    case (select) // synopsys parallel_case
EOS

for (my $i = 0 ; $i <= 15 ; $i++){
    my $num = substr(unpack('B8',  pack('C', $i)),4,4);
    print ("        4'b", $num, ": select16 = data");
    print (sprintf("%x",$i), ";\n");
}

print << 'EOS';
    endcase // case(select)
endfunction // select16

`endif // _select16_v_
EOS
