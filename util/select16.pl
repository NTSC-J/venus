#!/usr/bin/perl

use strict;
use warnings;

my $head = << 'EOS';
function [W_OPR -1: 0] select16;
    input [3: 0] select;

    input [W_OPR -1: 0] data0, data1, data2, data3;
    input [W_OPR -1: 0] data4, data5, data6, data7;
    input [W_OPR -1: 0] data8, data9, dataa, datab;
    input [W_OPR -1: 0] datac, datad, datae, dataf;

    case (select) // synopsys parallel_case
EOS
my $tail = << 'EOS';
    endcase // case(select)
endfunction // select16
EOS

print $head;
for (my $i = 0 ; $i <= 15 ; $i++){
    my $num = substr(unpack('B8',  pack('C', $i)),4,4);
    print ("        4'b", $num, ": select16 = data");
    print (sprintf("%x",$i), ";\n");
}
print $tail;

