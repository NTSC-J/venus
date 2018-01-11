module ifetch(clk, rst,
          v_o,
          branch_i, baddr_i, addr_o, origaddr_o,
          stall_i);

`include "include/params.vh"

    input clk, rst;
    output v_o;
    input branch_i; // whether to branch
    input [`ADDR - 1:0] baddr_i; // address to branch to
    output [`ADDR - 1:0] addr_o; // address to read next time
    output [`ADDR - 1:0] origaddr_o; // address of branch instruction
    input stall_i;

    // pipeline registers
    reg [`ADDR - 1:0] addr_r;
    reg [`ADDR - 1:0] origaddr_r;

    // internal registers
    reg branched_r;
    reg initialized_r;
    
    // connecting registers to output
    assign v_o = ~branch_i && ~branched_r && initialized_r;
    assign addr_o = addr_r;
    assign origaddr_o = origaddr_r;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            addr_r <= 0;
            origaddr_r <= 0;
            branched_r <= 0;
            initialized_r <= 0;
        end
        else begin
            if (~stall_i) begin
                origaddr_r <= addr_r;
                initialized_r <= 1'b1;
                if (branch_i) begin
                    addr_r <= baddr_i;
                    branched_r <= 1'b1;
                end
                else begin
                    addr_r <= addr_r + 1;
                    branched_r <= 1'b0;
                end
            end
        end
    end
endmodule

