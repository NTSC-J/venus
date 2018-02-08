`include "../include/params.vh"
module imem32x64k(clk, A, W, D, Q, Ao);
    parameter LEN = 65535;

    input clk;
    input [`ADDR - 1:0] A;
    input W;
    input [`WORD - 1:0] D;
    output [`WORD - 1:0] Q;
    output [`ADDR - 1:0] Ao;

    reg [`WORD - 1:0] mem_bank [0:LEN];

    reg [`WORD - 1:0] o_reg;
    reg [`ADDR - 1:0] o_addr_reg;

    assign Q = o_reg;
    assign Ao = o_addr_reg;

    always @(posedge clk) begin
        o_addr_reg <= A;
        if (W == 1'b1) // write
            mem_bank[A] <= D;
        else // read
            o_reg <= mem_bank[A];
    end

    initial begin
        o_reg = `WORD'b0;
        o_addr_reg = `ADDR'b0;
        $readmemh("../mem/imem.dat", mem_bank);
    end
endmodule // imem32x64k

