`include "include/params.vh"
`timescale 1ns/100ps

module test_addx();
    parameter STEP = 10;

    reg clk, rst;

    core c(.clk(clk), .rst(rst));

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        rst = 1'b0;

        #1.0;
        rst = 1'b1;
        #(STEP * 18);
        $finish;
    end // initial

    always @(posedge clk) begin : BREAK
        if (~rst) disable BREAK;
        $display("###### cycle ######");
        $display("IF:      branch_i %b, baddr_i %h",
                c.ifetch1.branch_i, c.ifetch1.baddr_i);
        $display("IF<->ID: v %b, s %b, addr %h, origaddr %h, inst %h",
                c.v_ifid, c.stall_idif, c.addr_ifmem,
                c.origaddr_ifid, c.inst_ifid);
        $display({"ID<->EX: v %b, s %b, src %h, dest %h,\n",
                  "         wb %b, rd_num %h, dopc %h, opc %h, origaddr %h"},
                c.v_idex, c.stall_exid, c.src_idex, c.dest_idex,
                c.wb_idex, c.rd_num_idex, c.dopc_idex, c.opc_idex,
                c.origaddr_idex);
        $display("EX<->WB: v %b, s %b, wb %b, rd_num %h, rd_data %h",
                c.v_exwb, c.stall_wbex, c.wb_exwb, c.rd_num_exwb,
                c.rd_data_exwb);
        $display({"ID<->RF: w_reserve %b, r0_num %h, r1_num %h,\n",
                  "         r0_data %h, r1_data %h, reserved %h"},
                c.w_reserve_idreg, c.r0_num_idreg, c.r1_num_idreg,
                c.r0_data_regid, c.r1_data_regid, c.reserved_regid);
        $display("WB-->RF: wb %b, wbr_num %h, wb_data %h",
                c.wb_wbreg, c.wbr_num_wbreg, c.wb_data_wbreg);
    end // always @(posedge clk)
endmodule

