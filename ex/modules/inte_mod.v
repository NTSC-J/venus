/*
 * EX module for integer ops
 *
 * used by instructions:
 * ADDx
 * SUBX
 * MULx
 * DIVx
 * CMPx
 * ABSx
 * ADCx
 * SBCx
 */

`include "include/mnemonic.vh"

function [`WORD + `W_STATUS - 1:0] inte_mod;
    input [`W_OPC - 1:0] opc_i;
    input [`WORD - 1:0] src_i;
    input [`WORD - 1:0] dest_i;

    reg signed [`WORD:0] temp; // 1bit wider
    reg zero, negative, positive, carry, underflow, overflow;

    begin
        case (opc_i)
        `ADDx:
            temp = src_i + dest_i;
        `SUBx:
            temp = dest_i - src_i; // TODO
        default:
            temp = {`WORD{1'b1}}; // DEBUG
        endcase
    
        zero = ~(|temp);
        negative = temp[`WORD - 1];
        positive = ~zero & ~negative;
        carry = temp[`WORD];
        // TODO
        overflow = 1'b0;
        underflow = 1'b0;
    
        inte_mod = {temp[`WORD - 1:0], zero, positive, carry, overflow, underflow};
    end
endfunction
