//
//  Final solution to P116B Lab 5.
//  It will count at 1 Hz, and display the result
//  in hexadecimal.
// They are provided with the nibble.seg program
// and they write binary2display
//
// 11-FEB-2020  E.Prebys Original
//
module au_top_0(
  input clk,              // 100 MHz onboard clock
  input [23:0] io_dip,    // 24 DIP switches
  output [23:0] io_led,   // 24 LEDs
  output [3:0] io_sel,    // digit selector, active LOW
  output [7:0] io_seg);   // segment drivers, active LOW
                          // 0->6 = segments A->G
                          // 7    = radix point (DP)

  wire [15:0] count;   // slow counter
  
  assign io_led[15:0]=count;   // Also display on the LEDs    
  
  assign io_led[23:16]=io_seg; // Have the segment drivers drive the high bits
    

// Slow counter routine, from last lab     
  slowcounter_1 #(.WIDTH(16)) sc (.clk(clk),.count(count));  
// Binary 2 display module, which they write for this lab
  binary2display_2 b2d 
     (.clk(clk),.data(count[15:0]),.sel(io_sel),.seg(io_seg));

     
endmodule