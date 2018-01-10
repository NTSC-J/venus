`include "include/params.vh"
`timescale 1ns/100ps

module test_run();
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
        #(STEP * 24);
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
        $display({"ID<->EX: v %b, s %b, src %h, dest %h, cc %b,\n",
                  "         wb %b, wb_rd_name %h, dopc %b, opc %b, origaddr %h"},
                c.v_idex, c.stall_exid, c.src_idex, c.dest_idex, c.cc_idex,
                c.wb_idex, c.wb_rd_name_idex, c.dopc_idex, c.opc_idex,
                c.origaddr_idex);
        $display({"ID<->RF: rd_reserve %b, rd_name %h, rs_name %h,\n",
                  "         rd_data %h, rs_data %h, rd_r %b, rs_r %b"},
                c.rd_reserve_idreg, c.rd_name_idreg, c.rs_name_idreg,
                c.rd_data_regid, c.rs_data_regid,
                c.rd_reserved_regid, c.rs_reserved_regid);
        $display("EX-->RF: wb %b, wb_rd_name %h, wb_rd_data %h",
                c.wb_exreg, c.wb_rd_name_exreg, c.wb_rd_data_exreg);
        $display({"Regs:    %h %h %h %h %h %h %h %h\n",
                  "         %h %h %h %h %h %h %h %h"},
                  c.register_file1.r0.data_o,
                  c.register_file1.r1.data_o,
                  c.register_file1.r2.data_o,
                  c.register_file1.r3.data_o,
                  c.register_file1.r4.data_o,
                  c.register_file1.r5.data_o,
                  c.register_file1.r6.data_o,
                  c.register_file1.r7.data_o,
                  c.register_file1.r8.data_o,
                  c.register_file1.r9.data_o,
                  c.register_file1.ra.data_o,
                  c.register_file1.rb.data_o,
                  c.register_file1.rc.data_o,
                  c.register_file1.rd.data_o,
                  c.register_file1.re.data_o,
                  c.register_file1.rf.data_o);
        $display("Status:  %b", c.execute1.status_r);
        $display("DATA:    %b", c.execute1.actual_data);
        $display("JDATA:   %b", c.execute1.jump_data);
    end // always @(posedge clk)
endmodule
