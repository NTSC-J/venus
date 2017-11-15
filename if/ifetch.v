module ifetch(clk, rst,
          v_o,
          inst_i, inst_o,
          branch_i, baddr_i, addr_o, origaddr_o,
          stall_i);

`include "include/params.vh"

    input clk, rst;
    output v_o;
    input [WORD - 1:0] inst_i;
    output [WORD - 1:0] inst_o;
    input branch_i; // whether branch or not
    input [ADDR - 1:0] baddr_i; // address to branch to
    output [ADDR - 1:0] addr_o; // address to read next time
    output [ADDR - 1:0] origaddr_o; // address of branch instruction
    input stall_i;

    // pipeline registers
    reg v_r;
    reg [ADDR - 1:0] addr_r;
    reg [ADDR - 1:0] origaddr_r;
    
    // connecting registers to output
    assign v_o = v_r;
    assign inst_o = inst_i;
    assign addr_o = addr_r;
    assign origaddr_o = origaddr_r;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
            addr_r <= 0;
            origaddr_r <= 0;
        end
        else begin
            if (~stall_i) begin
                origaddr_r <= addr_r;
                if (branch_i == 1'b1) begin
                    addr_r <= baddr_i;
                    v_r <= 1'b0;
                end
                else begin
                    addr_r <= addr_r + 1;
                    v_r <= 1'b1;
                end
            end
        end
    end
endmodule

