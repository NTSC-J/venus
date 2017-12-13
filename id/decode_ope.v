// decode opecode

`include "include/mnemonic.vh"
// dopc = {inte, shift, logic, load, store, branch}
function [`W_DOPC - 1:0] decode_ope;
    input [6:0] opecode;
    case (opecode) // synopsis parallel_case
        `ADDx, `SUBx, `CMPx, `ADCx, `SBCx:
            decode_ope = `W_DOPC'b100000000000;
        `MULx:
            decode_ope = `W_DOPC'b010000000000;
        `DIVx:
            decode_ope = `W_DOPC'b001000000000;
        `ABSx:
            decode_ope = `W_DOPC'b000100000000;
        `SHLx, `SHRx, `ASHx, `ROLx, `RORx:
            decode_ope = `W_DOPC'b000010000000;
        `AND, `OR, `NOT, `XOR:
            decode_ope = `W_DOPC'b000001000000;
        `SETL, `SETH:
            decode_ope = `W_DOPC'b000000100000;
        `LD:
            decode_ope = `W_DOPC'b000000010000;
        `ST:
            decode_ope = `W_DOPC'b000000001000;
        `J, `JA:
            decode_ope = `W_DOPC'b000000000100;
        `NOP:
            decode_ope = `W_DOPC'b000000000010;
        `HLT:
            decode_ope = `W_DOPC'b000000000001;
        default:
            decode_ope = `W_DOPC'b000000000000;
    endcase
endfunction

