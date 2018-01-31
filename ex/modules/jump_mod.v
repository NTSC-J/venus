/*
 * EX module for JUMP
 *
 * used by instructions:
 * J  (jump)
 * JA (jump absolute)
 */

`include "../include/mnemonic.vh"
`include "../include/cc.vh"

// {whether to branch, address}
function [`ADDR:0] jump_mod;
    input [`W_OPC - 1:0] opc_i;
    input [`W_CC - 1:0] cc_i;
    input signed [`WORD - 1:0] src_i;
    input [`ADDR - 1:0] origaddr_i;
    input [`W_STATUS - 1:0] status_i;

    reg branch; // whether to branch
    reg [`ADDR - 1:0] baddr;

    begin
        case (cc_i)
        `CC_ALWAYS:
            branch = 1'b1;
        `CC_ZERO:
            branch = status_i[`ZERO_BIT];
        `CC_POSITIVE:
            branch = status_i[`POSITIVE_BIT];
        `CC_NEGATIVE:
            branch = status_i[`NEGATIVE_BIT];
        `CC_CARRY:
            branch = status_i[`CARRY_BIT];
        `CC_OVERFLOW:
            branch = status_i[`OVERFLOW_BIT];
        default:
            branch = 1'bx;
        endcase

        case (opc_i)
        `J:
            baddr = origaddr_i + $signed(src_i);
        `JA:
            baddr = src_i;
        default:
            baddr = 0;
        endcase

        jump_mod = {branch, baddr};
    end
endfunction

