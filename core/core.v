/**
 * the top module for the Venus CPU
 */

module core(clk, rst);

`include "../include/params.vh"

    input clk, rst;

    /* wires */
    // wires for basic pipeline ops
    wire v_ifid, v_idex;
    wire stall_idif, stall_exid;
    // wires for IF, ID stages
    wire [`ADDR - 1:0] addr_ifmem, origaddr_memid;
    wire [`WORD - 1:0] inst_memid;
    // wires for IF, EX stages (jump)
    wire branch_exif;
    wire [`ADDR - 1:0] baddr_exif;
    // wires for ID, EX stages
    wire [`WORD - 1:0] src_idex, dest_idex;
    wire wb_idex;
    wire [`W_RD - 1:0] wb_rd_name_idex;
    wire [`W_DOPC - 1:0] dopc_idex;
    wire [`W_OPC - 1:0] opc_idex;
    wire [`ADDR - 1:0] origaddr_idex;
    wire [`W_CC - 1:0] cc_idex;
    // wires to/from the register file
    wire rd_reserve_idreg;
    wire [`W_RD - 1:0] rd_name_idreg, rs_name_idreg;
    wire [`WORD - 1:0] rd_data_regid, rs_data_regid;
    wire rd_reserved_regid, rs_reserved_regid;
    wire wb_exreg;
    wire [`W_RD - 1:0] wb_rd_name_exreg;
    wire [`WORD - 1:0] wb_rd_data_exreg;

    // data memory
    wire [`ADDR - 1:0] dm_addr_iddm, dm_addr_exdm;
    wire dm_w_exdm;
    wire [`WORD - 1:0] dm_data_exdm, dm_data_dmex;

    register_file register_file1(
        // global
        .clk(clk), .rst(rst),
        // ID
        .rd_reserve_i(rd_reserve_idreg),
        .rd_name_i(rd_name_idreg), .rs_name_i(rs_name_idreg),
        .rd_data_o(rd_data_regid), .rs_data_o(rs_data_regid),
        .rd_reserved_o(rd_reserved_regid),
        .rs_reserved_o(rs_reserved_regid),
        // EX 
        .wb_i(wb_exreg),
        .wb_rd_name_i(wb_rd_name_exreg),
        .wb_rd_data_i(wb_rd_data_exreg)
    );
    ifetch ifetch1(
        // global
        .clk(clk), .rst(rst),
        // ID
        .addr_o(addr_ifmem),
        // EX
        .branch_i(branch_exif), .baddr_i(baddr_exif),
        .stall_i(stall_idif), .v_o(v_ifid)
    );
    // instruction memory
    imem32x64k imem(
        .clk(clk), .A(addr_ifmem), .W(1'b0), .D(), .Q(inst_memid), .Ao(origaddr_memid)
    );
    idecode idecode1(
        // global
        .clk(clk), .rst(rst),
        // IF
        .v_i(v_ifid), .stall_o(stall_idif),
        .inst_i(inst_memid), .origaddr_i(origaddr_memid),
        // EX
        .src_o(src_idex), .dest_o(dest_idex),
        .wb_o(wb_idex), .wb_rd_name_o(wb_rd_name_idex),
        .dopc_o(dopc_idex), .opc_o(opc_idex),
        .origaddr_o(origaddr_idex),
        .cc_o(cc_idex),
        .dm_addr_o(dm_addr_iddm),
        .stall_i(stall_exid), .v_o(v_idex),
        // Register file
        .rd_reserve_o(rd_reserve_idreg),
        .rd_name_o(rd_name_idreg), .rs_name_o(rs_name_idreg),
        .rd_data_i(rd_data_regid), .rs_data_i(rs_data_regid),
        .rd_reserved_i(rd_reserved_regid),
        .rs_reserved_i(rs_reserved_regid)
    );
    execute execute1(
        // global
        .clk(clk), .rst(rst),
        // IF
        .branch_o(branch_exif), .baddr_o(baddr_exif),
        // ID
        .v_i(v_idex), .stall_o(stall_exid),
        .src_i(src_idex), .dest_i(dest_idex),
        .wb_i(wb_idex), .wb_rd_name_i(wb_rd_name_idex),
        .dopc_i(dopc_idex), .opc_i(opc_idex),
        .origaddr_i(origaddr_idex),
        .cc_i(cc_idex),
        // Register file
        .wb_o(wb_exreg), .wb_rd_name_o(wb_rd_name_exreg),
        .wb_rd_data_o(wb_rd_data_exreg),
        // data memory
        .dm_w_o(dm_w_exdm),
        .dm_data_o(dm_data_exdm), .dm_data_i(dm_data_dmex)
    );
    // data memory
    dmem32x64k dmem(
        .clk(clk), .A(dm_addr_iddm), .W(dm_w_exdm), .D(dm_data_exdm),
        .Q(dm_data_dmex)
    );
endmodule

