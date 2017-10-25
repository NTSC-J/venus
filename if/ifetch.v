module ifetch(clk, rst,
          v_i, v_o,
          inst_i, inst_o,
          branch_i, baddr_i, addr_o,
          stall_i, stall_o);
`include "include/params.vh"
    input clk, rst;
    input v_i;
    output v_o;
    input [WORD - 1:0] inst_i;
    output [WORD - 1:0] inst_o;
    input branch_i; // whether branch or not
    input baddr_i; // address to branch to
    output addr_o; // address to read next time
    input stall_i;
    output stall_o;

    // pipeline registers
    reg v_r;
    reg [WORD - 1:0] inst_r;
    reg [ADDR - 1:0] addr_r;
    
    // connecting registers to output
    assign v_o = v_r;
    assign inst_o = inst_r;
    assign addr_o = addr_r;

    // stall to previous stage
    assign stall_o = (v_r & stall_i);

    always @(posedge clk or negedge rst)
      begin
        if (~rst)
          begin
            v_r <= 0;
            inst_r <= 0;
            addr_r <= 0;
          end
        else
          begin
            if (~stall_i)
              begin
                v_r <= v_i;
                inst_r <= inst_i;
              end
          end
      end
endmodule

