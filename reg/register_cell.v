module register_cell(clk, rst,
                     data_i,
                     data_o,
                     w_reserve_i,
                     w_reserve_o,
                     wb_i
                     );
   input clk, rst;
   input  [W_OPR -1: 0] data_i; // data for write
   output [W_OPR -1: 0] data_o; // data output
   input                w_reserve_i; // write reserve
   output               w_reserve_o; // write reserve out
   input                wb_i; // write back

   reg [W_OPR-1: 0]     data_cell; // register cell
   reg                  w_res; // write reserve bit


   assign               data_o = data_cell;
   assign               w_reserved = w_res;

   always @(posedge clk or negedge rst)
     begin
        if (~rst)
          begin
             w_res <= 1'b0;
             data_cell <= 32'b0;
          end
        else
          begin
             if (w_reserve_i) // write reserve
               begin
                  w_res <= 1'b1;
               end
             else if (wb_i) // write back
               begin
                  w_res <= 1'b0;
               end

             if (wb_i)
               begin
                  data_cell <= data_i;
               end
          end // else: !if(~rst)
     end // always @ (posedge clk or negedge rst)
endmodule // register_cell

