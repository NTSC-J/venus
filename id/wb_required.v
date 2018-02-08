`include "../include/params.vh"
`include "../include/mnemonic.vh"

function wb_required;
    input [`W_OPC - 1:0] opecode;

    case (opecode)
    `CMPx, `ST, `J, `JA, `NOP, `HLT:
        wb_required = 1'b0;
    default:
        wb_required = 1'b1;
    endcase
endfunction

