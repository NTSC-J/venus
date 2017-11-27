module DP_mem32x64k(clk, A, W, D, Q);
`include "include/params.vh"
    parameter LEN = 65535;

    input clk;
    input [`ADDR - 1:0] A;
    input W;
    input [`WORD - 1:0] D;
    output [`WORD - 1:0] Q;

    reg [`WORD - 1:0] mem_bank [0:LEN];

    reg [`WORD - 1:0] o_reg;

    assign Q = o_reg;

    always @(posedge clk)
      begin
        if (W == 1'b1) // write
          mem_bank[A] <= D;
        else // read
          o_reg <= mem_bank[A];
      end

    initial begin
        $readmemh("mem/mem.dat", mem_bank);
    end
endmodule // DP_mem32x64k

