/*
 * EX module for logic ops
 *
 * used by instructions:
 * AND
 * OR
 * NOT
 * XOR
 */

`include "include/mnemonic.vh"

function [`WORD + `W_STATUS - 1:0] logic_mod;
    input [`W_OPC - 1:0] opc_i;
    input [`WORD - 1:0] src_i;
    input [`WORD - 1:0] dest_i;

    reg signed [`WORD - 1:0] rd;

    begin
        case (opc_i)
        `AND:
            rd = src_i & dest_i;
        `OR:
            rd = src_i | dest_i;
        `NOT:
            rd = ~src_i;
        `XOR:
            rd = src_i ^ dest_i; // TODO
        default:
            rd = 0;
        endcase
    
        logic_mod = {rd, `W_STATUS'b0};
    end
endfunction

