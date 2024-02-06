// binary2display
// --------------
// Module to use a 16 bin binary number to 
// drive the 4 digit hexidecimal display on the
// Alchitry-Io board
// Inputs:
//    clk  - 100 MHz onboard clock
//    data - 16-bit data word
// Outputs:
//    sel  - 4-bit digit select word, active LOW
//    seg  - 8-bit segment driver word, active LOW
//           DP bit will be tied HIGH (off).
// Dependencies:
//   nibble2seg(nib,seg)
//
// 11-FEB-2020  E. Prebys   Original
//

module binary2display_2 (
    input clk,   // clock
    input [15:0] data,     //16-bit data word
    output reg [3:0] sel,  //4-bit digit select, active LOW
    output [7:0] seg       //8-bit segment bits, active LOW
                           // 0-6 = A->G segments
                           // 7 = DP, tied HIGH (OFF) 
    );

    reg [8:0] clocks=0;    // clock cycle counter
    parameter CYCLE=260; // Number of clock ticks in a full cycle
                         // 100 ns wait, then 2.5 usec assert     
    
    reg [3:0] nibble;    // 4 bits of data
    reg [1:0] digit=0;     // digit counter, 0-3

    assign seg[7] = 1;   // Always tie DP HIGH (OFF)
    // Tie other bits to segment coversion of selected nibble
    nibble2seg_4 h2s (.nibble(nibble),.seg(seg[6:0]));
    
    always @(posedge clk) begin
      case(clocks) 
        0: sel=4'b1111;    // Turn all off for a few cycles to prevent
                           // Bleed through
       10: begin
             sel = ~(1<<digit);      // set the selected digit LOW
             nibble = data>>4*digit; // grab the correct nibble
           end
      CYCLE: begin                   // Reset counter and advance digit
            clocks=0;
            digit=digit+1;
          end
      endcase
      
      clocks = clocks+1;
    
    end
    
endmodule
