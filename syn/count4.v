module count4(
		//*************** port name list **************
		clk, // clock
		rst, // reset
		count // counter output
		//*********************************************
		);

   //************** port definition **************
   input clk, rst;
   // clock, reset
   output [3:0] count;
   // counter output
   //*********************************************

   //*********** parameter declaration ***********
   reg [3:0] 	counter;
   // count register

   wire [3:0] 	count_tmp;
   // count up value
   //*********************************************

   //********* combination logic circuit *********
   assign 	count = counter;
   // connect to output
   assign 	count_tmp = counter + 1'b1;
   // count up
   //*********************************************

   //*************** state machine ***************
   always @(posedge clk or negedge rst)
     begin
	if (~rst) // reset
	  begin
	     counter <= 4'b0;

	  end
	else
	  begin // count up
	     counter <= count_tmp;

	  end
     end // always @ (posedge clk or negedge rst)
   //*********************************************
endmodule // counter4
