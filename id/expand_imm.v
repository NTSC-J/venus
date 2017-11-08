// TODO: test
function [WORD - 1:0] expand_imm;
    input [W_OPC - 1:0] opecode;
    input [W_IMM - 1:0] imm;

    case (opecode)
        7'b000_0000,
        7'b000_0001,
        7'b000_0010,
        7'b000_0011,
        7'b000_0100,
        7'b000_0101,
        7'b000_0110,
        7'b000_0111,
        7'b001_1000,
        7'b001_1001,
        7'b001_1100,
        7'b001_1101:
            expand_imm = {16{imm[W_IMM - 1]}, imm};

        default:
            expand_imm = {16'b0, imm};
    endcase
endfunction

