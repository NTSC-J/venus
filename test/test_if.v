`timescale 1ns/100ps
module test_if();
`include "include/params.vh"
    parameter STEP = 10;

    reg clk, rst;
    reg branch_r;
    reg [ADDR - 1:0] baddr_r;

    top top(.clk(clk), .rst(rst),
         .v_i(1'b1), .stall_i(1'b0),
         .branch_i(branch_r), .baddr_i(baddr_r));

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        rst = 1'b0;
        branch_r = 1'b0;
        baddr_r = 0;

        #1.0;
        #(STEP * 128);
        rst = 1'b1;
        #(STEP);

        #(STEP * 4);
        branch_r = 1'b1;
        baddr_r = 2;
        #(STEP * 4);
        $finish;
    end // initial

    always @(posedge clk) begin
        $display("###### cycle ######");
        $display("branch_i baddr_i addr_o   inst_i   inst_o v_o");
        $display("       %b    %h   %h %h %h   %b",
                top.ifetch1.branch_i,
                top.ifetch1.baddr_i,
                top.ifetch1.addr_o,
                top.ifetch1.inst_i,
                top.ifetch1.inst_o,
                top.ifetch1.v_o);
    end // always @(posedge clk)
endmodule

