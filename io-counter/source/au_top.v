// Project Name: io-counter
// Author: Prof. Eric Prebys, UC Davis
// 
// Simple counter which will display on the segment displays of the
// Io board.  The io LED display will bounce back and forth and the
// Au LEDs will display the lower bits of the count.
// Behavior is selected by the first three DIP switches
//    io_dip[0] - 0 = count down, 1 = count up
//    io_dip[1] - 0 = count at 1 Hz, 1 = count at 10 Hz
//    io_dip[2] - 0 = display in HEX, 1 = display in DEC
//
//  Version history
//  1.0  EjP  20190409 - Original
//  1.1  EjP  20190410 - Changed io_led from count to bounce
//
module au_top(
    input clk,              // 100MHz clock
    input rst_n,            // reset button (active low)
    input [2:0] io_dip,     // dip switches
    output [7:0] led,       // 8 user controllable LEDs
    output [23:0] io_led,   // LEDs on IO board
    output [3:0] io_sel,    // segment driver displays
    output [7:0] io_seg     // io_segments
     );
     
    reg [15:0] count;   // 24-bit counter
    reg [31:0] delay;   // Counter delay, used to slow down clock

    reg [23:0] ledword=24'h000001;  //Going to make this bit bounce
    reg left_right=0;               //back and forth
    assign io_led=ledword;

    wire rst,up_down,fast,dec_hex;  // set by io_dip switdches
    wire [19:0] decimal_bytes; // decimal version of count  
    wire [15:0] display_bytes; // Bytes to display
    
    // Configure based on the DIP switches
    assign up_down=io_dip[0];  // Count up or down
    assign fast=io_dip[1];     // Fast (10Hz) or slow (1Hz)
    assign dec_hex=io_dip[2];  // Decimal or Hex display    
    assign display_bytes = dec_hex? decimal_bytes[15:0]: count[15:0];
    // Connect the LEDs on the alchitry board to the lowest 8 bits 
    assign led=count[7:0];
 
    // instantiations...
    // The first one is part of the standard default Alchitry project
    // The reset conditioner is used to synchronize the reset signal to the FPGA
    // clock. This ensures the entire FPGA comes out of reset at the same time.
    reset_conditioner reset_conditioner(.clk(clk), .in(!rst_n), .out(rst));
    
    // Local instantiations...
    // convert hexadecimal to decimal
    hex2bcd hex2bcd(.hex(count[15:0]),.dec(decimal_bytes));
    // This will display 4 bytes on the 4 segment displays. Which bytes are 
    // displayed are selected by io_dip[2] above
    fourhexdisplay fourhexdisplay(.clk(clk),.dataword(display_bytes),.sel(io_sel),.seg(io_seg));
    
     
 
    //Counting block
    always @ (posedge clk,posedge rst) begin
       if (rst==1)  count=0;  
       // Advance every 100M clocks (slow) or 10M clocks (FAST)       
       else if ((delay==100000000)||((fast==1)&&(delay==10000000))) begin
          if (up_down == 1) begin                      // Handle counting direction
            count = count+1;
            if((dec_hex==1)&&(count==10000)) count=0;  //correctly handle wrapping for dec
          end else begin
            if((dec_hex==1)&&(count==0)) count=10000;
            count = count-1;
          end
          delay=0;
          // Make the LED display bounce back and forth at the clock rate
          if (ledword==24'h800000) left_right=1;
          else if (ledword==24'h000001) left_right=0;
          if (left_right==1) ledword = ledword >> 1;
          else ledword = ledword << 1;
        end
          
       delay = delay+1;
    end
    
endmodule