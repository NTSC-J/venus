/*
 * EX module for shift ops
 *
 * used by instructions:
 * SHLx
 * SHRx
 * ASHx
 * ROLx
 * RORx
 */

`include "../include/mnemonic.vh"

function [`WORD + `W_STATUS - 1:0] shift_mod;
    input [`W_OPC - 1:0] opc_i;
    input [`WORD - 1:0] src_i;
    input [`WORD - 1:0] dest_i;

    reg signed [`WORD + `WORD - 2:0] temp;
    reg zero, negative, positive, carry, underflow, overflow;

    begin
        case (opc_i)
        `SHLx:
            temp = dest_i << src_i;
        `SHRx:
            temp = dest_i >> src_i;
        `ASHx:
            temp = $signed(dest_i) >>> src_i;
        // TODO: ROLx, RORx
        default:
            temp = 0;
        endcase
    
        // TODO
        zero = ~(|temp);
        negative = temp[`WORD - 1];
        positive = ~zero & ~negative;
        carry = temp[`WORD];
        // TODO
        overflow = 1'b0;
        underflow = 1'b0;
    
        shift_mod = {temp[`WORD - 1:0], zero, positive, negative, carry, overflow, underflow};
    end
endfunction

