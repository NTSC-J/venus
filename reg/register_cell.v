`include "include/params.vh"
module register_cell(clk, rst,
                     data_i,
                     data_o,
                     w_reserve_i,
                     w_reserved_o,
                     wb_i,
                     w_unreserve_i
                     );
   input clk, rst;

   input                w_reserve_i;    // write reserve
   output               w_reserved_o;   // write reserve out
   output [`WORD -1: 0] data_o;         // data output

   input                wb_i;           // request writeback
   input                w_unreserve_i;    // write unreserve
   input  [`WORD -1: 0] data_i;         // data to write

   reg [`WORD-1: 0]     data_r;         // register cell
   reg                  w_reserved_r;   // write reserve bit

   assign               data_o = data_r;
   assign               w_reserved_o = w_reserved_r;

   always @(posedge clk or negedge rst) begin
        if (~rst) begin
             w_reserved_r <= 1'b0;
             data_r <= 32'b0;
        end
        else begin
             if (w_reserve_i) // write reserve
                 w_reserved_r <= 1'b1;
             else if (w_unreserve_i) // write back
                 w_reserved_r <= 1'b0;

             if (wb_i)
                 data_r <= data_i;
        end
   end // always @(posedge clk or negedge rst)
endmodule

