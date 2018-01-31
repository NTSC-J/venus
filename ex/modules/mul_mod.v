/*
 * EX module for MUL
 *
 * used by the instruction:
 * MULx (signed multiplication)
 */

`include "../include/mnemonic.vh"

function [`WORD + `W_STATUS - 1:0] mul_mod;
    input [`WORD - 1:0] src_i;
    input [`WORD - 1:0] dest_i;

    reg signed [`WORD * 2 - 1:0] temp;
    reg zero, negative, positive, carry, underflow, overflow;

    begin
        temp = $signed(dest_i) * $signed(src_i);

        zero = ~(|temp);
        negative = temp[`WORD - 1];
        positive = ~zero & ~negative;
        carry = 1'b0;
        if (positive)
            overflow = |(temp[`WORD * 2 - 1:`WORD]);
        else
            overflow = |(~temp[`WORD * 2 - 1:`WORD]);
        underflow = 1'b0;
    
        mul_mod = {temp[`WORD - 1:0], zero, positive, negative, carry, overflow, underflow};
    end
endfunction

