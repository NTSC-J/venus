`include "include/params.vh"

function may_jump;
    input [`W_OPC - 1:0] opecode;

    may_jump = opecode[`W_OPC - 1:1] == 6'b001_110;
endfunction

