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
        $display("IF<->ID: v %b, s %b, addr %h, origaddr %h",
                c.v_ifid, c.stall_idif, c.addr_ifmem,
                c.origaddr_ifid);
        $display("IM-->ID: inst %h",
                c.inst_memid);
        $display({"ID<->EX: v %b, s %b, src %h, dest %h,\n",
                  "         wb %b, rd_num %h, dopc %b, opc %b, origaddr %h"},
                c.v_idex, c.stall_exid, c.src_idex, c.dest_idex,
                c.wb_idex, c.rd_num_idex, c.dopc_idex, c.opc_idex,
                c.origaddr_idex);
        $display({"ID<->RF: w_reserve %b, r0_num %h, r1_num %h,\n",
                  "         r0_data %h, r1_data %h, reserved %h"},
                c.w_reserve_idreg, c.r0_num_idreg, c.r1_num_idreg,
                c.r0_data_regid, c.r1_data_regid, c.reserved_regid);
        $display("EX-->RF: wb %b, rd_num %h, rd_data %h",
                c.wb_exreg, c.rd_num_exreg, c.rd_data_exreg);
        $display({"Regs:    %h %h %h %h %h %h %h %h\n",
                  "         %h %h %h %h %h %h %h %h"},
                  c.g_register1.r0.data_o,
                  c.g_register1.r1.data_o,
                  c.g_register1.r2.data_o,
                  c.g_register1.r3.data_o,
                  c.g_register1.r4.data_o,
                  c.g_register1.r5.data_o,
                  c.g_register1.r6.data_o,
                  c.g_register1.r7.data_o,
                  c.g_register1.r8.data_o,
                  c.g_register1.r9.data_o,
                  c.g_register1.ra.data_o,
                  c.g_register1.rb.data_o,
                  c.g_register1.rc.data_o,
                  c.g_register1.rd.data_o,
                  c.g_register1.re.data_o,
                  c.g_register1.rf.data_o);
        $display("Status:  %b", c.execute1.status_r);
    end // always @(posedge clk)
endmodule

