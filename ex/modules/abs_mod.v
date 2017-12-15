/*
 * EX module for ABS
 *
 * used by the instruction:
 * ABSx
 */

function [`WORD + `W_STATUS - 1:0] abs_mod;
    input signed [`WORD - 1:0] src_i;

    reg signed [`WORD- 1:0] temp;
    reg zero, negative, positive, carry, underflow, overflow;

    begin
        if (src_i[`WORD - 1]) // negative
            temp = ~src_i + 1'b1;
        else
            temp = src_i;

        zero = ~(|temp);
        negative = temp[`WORD - 1]; // should be 0
        positive = ~zero & ~negative;
        carry = 1'b0;
        overflow = 1'b0;
        underflow = 1'b0;
    
        abs_mod = {temp[`WORD - 1:0], zero, positive, negative, carry, overflow, underflow};
    end
endfunction

