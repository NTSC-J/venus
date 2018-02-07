/*
 * EX module for ADD/SUB
 *
 * used by instructions:
 * ADDx (signed addition)
 * SUBx (signed subtraction)
 * CMPx (comparison, no rd writeback)
 *
 * not implemented:
 * ADCx (add with carry)
 * SBCx (subtract with borrow)
 */

`include "../include/mnemonic.vh"

function [`WORD + `W_STATUS - 1:0] addsub_mod;
    input [`W_OPC - 1:0] opc_i;
    input [`WORD - 1:0] src_i;
    input [`WORD - 1:0] dest_i;

    reg signed [`WORD:0] temp; // 1bit wider
    reg zero, negative, positive, carry, underflow, overflow;
    reg minus;

    begin
        case (opc_i)
        `ADDx:
            minus = 1'b0;
        `SUBx, `CMPx:
            minus = 1'b1;
        default:
            minus = 1'bx;
        endcase

        temp = minus + dest_i + (minus ? ~src_i : src_i);

        zero = ~(|temp);
        negative = temp[`WORD - 1];
        positive = ~zero & ~negative;
        carry = temp[`WORD];
        // TODO
        overflow = 1'b0;
        underflow = 1'b0;
    
        addsub_mod = {temp[`WORD - 1:0], zero, positive, negative, carry, overflow, underflow};
    end
endfunction

