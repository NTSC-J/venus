`include "../include/params.vh"
`timescale 1ns/100ps

`define CYCLES 64
`define BG_BRIGHTBLACK "\33[100m"
`define BG_RED "\33[41m"
`define BG_CYAN "\33[46m"
`define FG_BLACK "\33[30m"
`define WEAK_COLOR {`BG_BRIGHTBLACK, `FG_BLACK}
`define STRONG_COLOR {`BG_CYAN, `FG_BLACK}
`define CYC_COLOR {`BG_RED, `FG_BLACK}
`define RESET_COLOR "\33[0m"

module test_run();
    parameter STEP = 10;

    reg clk, rst;
    integer cycle;
    reg [12*8-1:0] color;

    core c(.clk(clk), .rst(rst));

    always begin
        #(STEP/2) clk = ~clk;
    end

    initial begin
        clk = 1'b0;
        rst = 1'b0;

        #1.0;
        rst = 1'b1;
        for (cycle = 0; cycle < `CYCLES; cycle = cycle + 1)
             #(STEP);

        $finish;
    end // initial

    always @(posedge clk) begin : BREAK
        if (~rst) disable BREAK;

        $display({`CYC_COLOR, "### cycle%3d ###", `RESET_COLOR}, cycle);

        if (c.ifetch1.branch_i) color = `STRONG_COLOR;
        else color = `RESET_COLOR;
        $display("%0sIF:      branch_i %b, baddr_i %h%0s",
                color, c.ifetch1.branch_i, c.ifetch1.baddr_i, `RESET_COLOR);

        //if (~c.idecode1.v_i) $write(`WEAK_COLOR);
        if (~c.idecode1.v_i) color = `WEAK_COLOR;
        else color = `RESET_COLOR;
        $display("%0sIF-->ID: v %b",
                color, c.v_ifid);
        $display("%0sIF-->IM: addr %h",
                color, c.addr_ifmem);
        $display("%0sIM-->ID: inst %h, origaddr %h%0s",
                color, c.inst_memid, c.origaddr_memid, `RESET_COLOR);

        $display({"ID<->RF: rd_reserve %b, rd_name %h, rs_name %h,\n",
                  "         rd_data %h, rs_data %h, rd_r %b, rs_r %b"},
                c.rd_reserve_idreg, c.rd_name_idreg, c.rs_name_idreg,
                c.rd_data_regid, c.rs_data_regid,
                c.rd_reserved_regid, c.rs_reserved_regid);
        
        if (~c.v_idex) color = `WEAK_COLOR;
        else color = `RESET_COLOR;
        $display({"%0sID-->EX: v %b, src %h, dest %h, cc %b,\n",
                  "%0s         wb %b, wb_rd_name %h, dopc %b, opc %b, origaddr %h%0s"},
                color, c.v_idex, c.src_idex, c.dest_idex, c.cc_idex,
                color, c.wb_idex, c.wb_rd_name_idex, c.dopc_idex, c.opc_idex, c.origaddr_idex, `RESET_COLOR);

        if (~c.wb_exreg) color = `WEAK_COLOR;
        else color = `RESET_COLOR;
        $display("%0sEX-->RF: wb %b, wb_rd_name %h, wb_rd_data %h%0s",
                color, c.wb_exreg, c.wb_rd_name_exreg, c.wb_rd_data_exreg, `RESET_COLOR);

        $display("ID-->DM: data_addr %h", c.data_addr_iddm);
        $display("EX<->DM: data_w %b, data_exdm %h, data_dmex %h",
                c.data_w_exdm, c.data_exdm, c.data_dmex);

        if (c.stall_idif | c.stall_exid) color = `STRONG_COLOR;
        else color = `WEAK_COLOR;
        $display("%0sSTALL:   idif %b, exid %b%0s", color, c.stall_idif, c.stall_exid, `RESET_COLOR);

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

