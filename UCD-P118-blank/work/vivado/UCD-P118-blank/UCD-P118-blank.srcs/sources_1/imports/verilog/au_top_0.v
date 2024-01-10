// This is a blank template project for UC Davis class 116B, to be used as a starting point for the labs.
// The Alchitry-UCD.asf constraints file contains all the pin definitions from
//   - Alchitry-Au
//   - Alchitry-Io
//   - A custom version of the Alchitry-Br that has six user IO pins (UCD-io[5:0]) as well as the VP and VN analog
//     inputs
// with all the unused pins commented out.
// 
// This dummy version just ties the DIPs to the LEDs.
//
//  3-FEB-2021  Eric Prebys  Original
//
module au_top_0(
    input clk,                  // 100 MHz onboard clock
    input [23:0] io_dip,        // 24 DIP switches on Alchitry-Io
    output [7:0] led,           // 8 LEDs on Au board    
    output [23:0] io_led);      // 24 LEDs on Io board
 
assign led = io_dip[7:0];       // Set Au LEDs to first 8 DIP switches   
assign io_led = io_dip;         // Tie all the DIP switches to all the Io LEDs
                    
endmodule