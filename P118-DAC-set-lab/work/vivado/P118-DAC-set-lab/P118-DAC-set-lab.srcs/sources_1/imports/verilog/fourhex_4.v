// This module is designed to drive the four digit Hex display
// on an Alchitry Io board.  This will simply loop over the digits
// as fast as possible and display what's on the inputs.  Takes about
// 10 usec to display all 4 digits.
//  Inputs:
//    clk         - onboard 100 MHz clk
//    dataword[15:0] - 16 bit word
//  Outputs:
//    sel[3:0]    - Active low digit selector
//    seg[7:0]    - Active low segment driver (7 segements+DP)
//
module fourhexdisplay_4 (
    input clk,  // clock
    input [15:0] dataword,  // 16-bit register
    output reg [3:0] sel, // low aseerted digit select
    output  [7:0] seg  // 7-segment driver+DP
  );  
  // State machine to control operation
  reg [1:0] state=0;   // state machine
  parameter IDLE=0,START=1,SET=2,END=3;

  reg [1:0] digit=0;   // digit counter
  reg [3:0] nibble;    // four bits to decode
  wire [6:0] seg7;     // decoded 7 segment
  reg [7:0] hold=0;   // time to hold each digit. Required by display chip (2.5 usec)
  
  // Convert the selected nibble to 7 segment
  hex7segment_5 hex7segment(nibble,seg7);
  assign seg={1'b1,seg7};   // Turn DP off

  // State machine will go from IDLE -> START ->SET (for "hold" cycles) ->END->IDLE
  always @ (posedge clk) begin
     case (state)
       IDLE: begin
          sel = 4'b1111;        // don't select any
          state = START;
          hold = 0;
       end
       START: begin
         nibble = (dataword>>(digit*4));  // Select the correct nibble
         state = SET;
       end
       SET: begin
         sel = ~(1<<digit);            // Asset the correct active low select
         hold = hold+1;                // Have to hold each digit for enough time to display
         if (hold==0) state = END;
       end
       END: begin                      // Unselect
         sel = 4'b1111;
         digit = digit+1;              // Increment digit
         state = IDLE;                 
       end
     endcase  
          
       
  end  
endmodule
