/*
 * EX module for SET
 *
 * used by instructions:
 * SETL
 * SETH
 */

`include "include/mnemonic.vh"

function [`WORD + `W_STATUS - 1:0] set_mod;
    input [`W_OPC - 1:0] opc_i;
    input [`WORD - 1:0] src_i;
    input [`WORD - 1:0] dest_i; // only lower 16 bits are used

    reg [`WORD - 1:0] temp;
    reg zero, negative, positive, carry, underflow, overflow;
    reg minus;

    begin
        case (opc_i)
        `SETL:
            temp = {dest_i[31:16], src_i[15:0]};
        `SETH:
            temp = {src_i[15:0], dest_i[15:0]};
        default:
            temp = `WORD'b0;
        endcase

        zero = ~(|temp);
        negative = temp[`WORD - 1];
        positive = ~zero & ~negative;
        carry = 1'b0;
        overflow = 1'b0;
        underflow = 1'b0;
    
        set_mod = {temp, zero, positive, negative, carry, overflow, underflow};
    end
endfunction

