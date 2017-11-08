// decode opecode
// dopc = {inte, shift, logic, load, store, branch}
`define W_DOPC 6
function [W_DOPC - 1:0] decode_ope;
    input [6:0] opecode;
    case (opecode) // synopsis parallel_case
        // integer
        7'b000_0000,
        7'b000_0001,
        7'b000_0010,
        7'b000_0011,
        7'b000_0100,
        7'b000_0101,
        7'b000_0110,
        7'b000_0111:
            decode_ope = 11'b100000;

        // shift
        7'b000_1000,
        7'b000_1001,
        7'b000_1010,
        7'b000_1011,
        7'b000_1100,
        7'b000_1101:
            decode_ope = 11'b010000;
            
        // logic
        7'b001_0000,
        7'b001_0001,
        7'b001_0010,
        7'b001_0011:
            decode_ope = 11'b001000;

        // load
        7'b001_1000:
            decode_ope = 11'b000100;

        // store
        7'b001_1001:
            decode_ope = 11'b000010;

        // branch
        7'b001_1100,
        7'b001_1101:
            decode_ope = 11'b000001;

        default:
            decode_ope = 11'b000000;
    endcase
endfunction

