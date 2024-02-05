// Module will test of a channel os over a threshold, and
// if it is, it will issue a read enable (we) and then
// increment the hit counter (nhit)
//
// 13-FEB-2020  E.Prebys  Original
//
module hitcounter_4 (
    input clk,             // clock
    input ss,              // synchronous start
    input running,         // running (from address generator)
    input [15:0] data,     // data (from bus)
    input [15:0] thresh,   // threshold (hardwired on board)
    output we,             // write enable
    output reg [8:0] nhit  // total number of tracks above threshold
    );
    
    //We want to do combinatorial logic on the comparison
    //so it's ready for the clock
    assign we = (data>thresh)&(running==1); // Note: could say (D>TH)&RUNNING

    always @(posedge clk) begin //totally synchronous
      // With our logic, there will be one cycle between SS and RUNNING.
      // so we'll use it to reset the counter
      if ((ss==1)&(running==0)) nhit=0;
      
      if (we==1) nhit=nhit+1;  // Increment the counter for every WE
      
   end
      
endmodule
