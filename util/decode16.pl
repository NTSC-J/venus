#!/usr/bin/perl

use strict;
use warnings;

print << "EOS";
`ifndef _decode16_v_
`define _decode16_v_

function [15:0] decode16;
    input [3:0] d;
    case (d) // synopsys parallel_case
EOS

for (my $i = 0 ; $i <= 15 ; $i++){
    my $num = substr(unpack('B8',  pack('C', $i)),4,4);
    print ("        4'b", $num, ": decode16 = 16'b");
    for (my $j = 15; $j >= 0 ; $j--){
	if ($j == $i){
	    print "1";
	}else {
	    print "0";
	}
    }
    print ";\n";
}

print << "EOS";
    endcase // case(d)
endfunction // decode16

`endif // _decode16_v_
EOS
