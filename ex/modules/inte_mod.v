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
        temp = dest_r - src_i; // TODO
    default:
        temp = 0;
    endcase
    
    reg zero = &(~temp);
    reg negative = temp[WORD - 1];
    reg positive = ~zero & ~negative;
    reg carry = temp[WORD];
    // TODO
    reg overflow = 1'b0;
    reg underflow = 1'b0;

    inte_mod = {temp[WORD - 1:0], zero, positive, carry, overflow, underflow
   };
endfunction

