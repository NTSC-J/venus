`timescale 1ns/100ps
module test_if();
    parameter STEP = 10;

    reg clk, rst;

    top top(.clk(clk), .rst(rst));

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        rst = 1'b0;

        #1.0;
        #(STEP * 128);
        rst = 1'b1;
        #(STEP);

        #(STEP * 32);
        $finish;
    end // initial

    always @(posedge clk) begin
        $display("inst_o: %h", top.ifetch1.inst_o);
    end // always @(posedge clk)
endmodule

