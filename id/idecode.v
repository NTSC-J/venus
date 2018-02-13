module idecode(
    // global
    clk, rst,
    // IF
    v_i, stall_o,
    inst_i,             // instruction
    origaddr_i,         // addr of the instruction
    // EX
    src_o, dest_o,      // read register/imm data
    wb_o,               // whether writeback is required
    wb_rd_name_o,       // register name of rd (used for WB)
    dopc_o,             // decoded opecode
    opc_o,              // raw opecode
    origaddr_o,
    cc_o,
    dm_addr_o,        // data memory address for load/store
    stall_i, v_o,
    // register file
    rd_reserve_o,
    rd_name_o, rd_data_i, rd_reserved_i,
    rs_name_o, rs_data_i, rs_reserved_i
);

`include "../include/params.vh"
`include "../id/decode_ope.v"
`include "../id/expand_imm.v"
`include "../id/wb_required.v"

    // global
    input clk, rst;
    // IF
    input v_i;
    output stall_o;
    input [`WORD - 1:0] inst_i;
    input [`ADDR - 1:0] origaddr_i;
    // EX
    output [`WORD - 1:0] src_o, dest_o;
    output wb_o;
    output [`W_RD - 1:0] wb_rd_name_o;
    output [`W_DOPC - 1:0] dopc_o;
    output [`W_OPC - 1:0] opc_o;
    output [`ADDR - 1:0] origaddr_o;
    output [`W_CC - 1:0] cc_o;
    output [`ADDR - 1:0] dm_addr_o;
    output v_o;
    input stall_i;
    // register file
    output rd_reserve_o;
    output [`W_RD - 1:0] rd_name_o, rs_name_o;
    input [`WORD - 1:0] rd_data_i, rs_data_i;
    input rd_reserved_i, rs_reserved_i;

    // pipeline registers
    reg v_r;
    reg [`WORD - 1:0] src_r, dest_r;
    reg [`W_DOPC - 1:0] dopc_r;
    reg [`W_OPC - 1:0] opc_r;
    reg [`ADDR - 1:0] origaddr_r;
    reg [`W_CC - 1:0] cc_r;
    reg [`ADDR - 1:0] dm_addr_r;
    reg wb_r;
    reg [`W_RD - 1:0] wb_rd_name_r;

    // connecting registers to output
    assign v_o = v_r;
    assign src_o = src_r;
    assign dest_o = dest_r;
    assign dopc_o = dopc_r;
    assign opc_o = opc_r;
    assign origaddr_o = origaddr_r;
    assign cc_o = cc_r;
    assign dm_addr_o = dm_addr_r;
    assign wb_o = wb_r;
    assign wb_rd_name_o = wb_rd_name_r;

    // decoding the instruction
    wire [`W_OPC - 1:0] opecode = inst_i[`OPC_MSB:`OPC_LSB];
    wire immf = inst_i[`IMMF_BIT];
    wire [`W_RD - 1:0] rd_name = inst_i[`RD_MSB:`RD_LSB];
    wire [`W_CC - 1:0] cc = rd_name[`W_CC - 1:0];
    wire [`W_RS - 1:0] rs_name = inst_i[`RS_MSB:`RS_LSB];
    wire [`W_IMM - 1:0] imm = inst_i[`IMM_MSB:`IMM_LSB];
    wire [`ADDR - 1:0] dm_addr = rs_data_i + $signed(imm); // LD/ST

    wire [`W_DOPC - 1:0] dopc = decode_ope(opecode);
    wire wb = wb_required(opecode);

    wire v = v_i & ~rd_reserved_i & ~(~immf & rs_reserved_i);

    assign stall_o = v_i & (stall_i | rd_reserved_i | (~immf & rs_reserved_i));
    // connected to RF, without pipeline registers
    assign rd_reserve_o = v & wb;
    assign rd_name_o = rd_name;
    assign rs_name_o = rs_name;

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            v_r <= 0;
            src_r <= 0;
            dest_r <= 0;
            dopc_r <= 0;
            opc_r <= 0;
            origaddr_r <= 0;
            cc_r <= 0;
            dm_addr_r <= 0;
            wb_r <= 0;
            wb_rd_name_r <= 0;
        end
        else begin
            if (~stall_i) begin
                v_r <= v;
                if (immf)
                    src_r <= expand_imm(opecode, imm);
                else
                    src_r <= rs_data_i;

                dest_r <= rd_data_i;
                dopc_r <= dopc;
                opc_r <= opecode;
                origaddr_r <= origaddr_i;
                cc_r <= cc;
                dm_addr_r <= dm_addr;
                wb_rd_name_r <= rd_name;
                wb_r <= wb;
            end
        end
    end
endmodule

