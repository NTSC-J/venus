/**
 * the top module for the Venus CPU
 */

module top(clk, rst);

`include "include/params.vh"

    input clk, rst;

    /* wires */
    // wires for basic pipeline ops
    wire v_ifid, v_idex, v_exwb;
    wire stall_idif, stall_exid, stall_wbex;
    // wires for IF, ID stages
    wire [ADDR - 1:0] addr_ifid, origaddr_ifid;
    wire [WORD - 1:0] inst_mem, inst_ifid;
    // wires for ID, EX stages
    wire [WORD - 1:0] src_idex, dest_idex;
    wire wb_idex;
    wire [W_RD - 1:0] rd_num_idex;
    wire [W_DOPC - 1:0] dopc_idex;
    wire [W_OPC - 1:0] opc_idex;
    wire [ADDR - 1:0] origaddr_idex;
    // wires for EX, WB stages
    // wires to/from the register file
    wire w_reserve_idreg;
    wire [W_RD - 1:0] r0_num_idreg, r1_num_idreg;
    wire [WORD - 1:0] r0_data_regid, r1_data_regid;
    wire reserved_regid;
    wire wb_wbreg;
    wire [W_RD - 1:0] wbr_num_wbreg;
    wire [WORD - 1:0] wb_data_wbreg;

    g_register g_register1(
        // global
        .clk(clk), .rst(rst),
        // ID
        .w_reserve_i(w_reserve_idreg),
        .r0_num_i(r0_num_idreg), .r1_num_i(r1_num_idreg),
        .r0_data_o(r0_data_regid), .r1_data_o(r1_data_regid),
        .reserved_o(reserved_regid),
        // WB
        .wb_i(wb_wbreg),
        .wbr_num_i(wbr_num_wbreg),
        .wb_data_i(wb_data_wbreg)
    );
    ifetch ifetch1(
        .clk(clk), .rst(rst),
        .inst_i(inst_mem), .inst_o(inst_ifid),
        .branch_i(1'b0), .baddr_i({ADDR{1'b0}}),
        .addr_o(addr_ifid), .origaddr_o(origaddr_ifid),
        .stall_i(stall_idif), .v_o(v_ifid)
    );
    // instruction memory
    DP_mem32x64k imem(
        .clk(clk), .A(addr), .W(1'b0), .D(), .Q(inst_mem)
    );
    idecode idecode1(
        // global
        .clk(clk), .rst(rst),
        // IF
        .v_i(v_ifid), .stall_o(stall_idif),
        .inst_i(inst_ifid), .origaddr_i(origaddr_ifid),
        // EX
        .src_o(src_idex), .dest_o(dest_idex),
        .wb_o(wb_idex), .rd_num_o(rd_num_idex),
        .dopc_o(dopc_idex), .opc_o(opc_idex),
        .origaddr_o(origaddr_idex),
        .stall_i(stall_exid), .v_o(v_idex),
        // Register file
        .w_reserve_o(w_reserve_idreg),
        .r0_num_o(r0_num_idreg), .r1_num_o(r1_num_idreg),
        .r0_data_i(r0_data_regid), .r1_data_i(r1_data_regid),
        .reserved_i(reserved_regid)
    );
    execute execute1(
        // global
        .clk(clk), .rst(rst),
        // ID
        .v_i(v_idex), .stall_o(stall_exid),
        .wb_i(wb_idex), .rd_num_i(rd_num_idex),
        .dopc_i(dopc_idex), .opc_i(opc_idex),
        .origaddr_i(origaddr_idex),
        .stall_i(stall_wbex), .v_o(v_exwb),
        // WB
    );
    // TODO: data memory
    writeback writeback1(
        // global
        .clk(clk), .rst(rst),
        // EX
        .v_i(v_exwb), .stall_o(stall_wbex)
    );
endmodule

