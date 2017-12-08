// decode opecode

`include "include/mnemonic.vh"
// dopc = {inte, shift, logic, load, store, branch}
function [`W_DOPC - 1:0] decode_ope;
    input [6:0] opecode;
    case (opecode) // synopsis parallel_case
        // integer
        `ADDx, `SUBx, `MULx, `DIVx, `CMPx, `ABSx, `ADCx, `SBCx:
            decode_ope = 11'b100000;

        // shift/rotate
        `SHLx, `SHRx, `ASHx, `ROLx, `RORx:
            decode_ope = 11'b010000;
            
        // logic
        `AND, `OR, `NOT, `XOR:
            decode_ope = 11'b001000;

        // set
        // load
        `LD:
            decode_ope = 11'b000100;

        // store
        `ST:
            decode_ope = 11'b000010;

        // branch
        `J, `JA:
            decode_ope = 11'b000001;
        // other

        default:
            decode_ope = 11'b000000;
    endcase
endfunction

