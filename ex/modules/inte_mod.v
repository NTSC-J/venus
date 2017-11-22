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

function [WORD + W_FLAGS - 1:0] inte_mod;
    input [W_OPC - 1:0] opc_i;
    input [WORD - 1:0] src_i, dest_i;

    reg [WORD:0] temp; // 1bit wider

    case (opc_i)
    ADDx:
        temp = src_i + dest_i;
    SUBx:
        temp = dest_i - src_i; // TODO
    default:
        temp = 0;
    endcase
    
    reg zero, negative, positive, carry, underflow, overflow;
    assign zero = ~(|temp);
    assign negative = temp[WORD - 1];
    assign positive = ~zero & ~negative;
    assign carry = temp[WORD];
    // TODO
    assign overflow = 1'b0;
    assign underflow = 1'b0;

    inte_mod = {temp[WORD - 1:0], zero, positive, carry, overflow, underflow
   };
endfunction

