// nibble2seg
// ----------
// Module to convert 4-bit nibble to the seven 
// segment active low driver bits on the 
// LDS-SMHTA304RISITR display chip used
// on the Alchitry-Io board. 
//
// Usage:
//  Inputs:
//     nibble - 4-bit number from 0 to 15
//  Outputs
//     seg    - 7-bit segment driver bits, active LOW
// Note:  radix bit will have to be driven separately!
//
// 11-FEB-2020 E. Prebys   Original
//
module nibble2seg (
    input [3:0] nibble,   // 4-bit nibble
    output reg [6:0] seg  // 7-bit segment driver, active LOW
  );
  
  always @*
  case (nibble)  // No clever way to do this. Just brute force
    0: seg=7'b1000000;
    1: seg=7'b1111001;
    2: seg=7'b0100100; 
    3: seg=7'b0110000;
    4: seg=7'b0011001;
    5: seg=7'b0010010;
    6: seg=7'b0000010;
    7: seg=7'b1111000;
    8: seg=7'b0000000;
    9: seg=7'b0010000;
    10: seg=7'b0001000;  //A
    11: seg=7'b0000011;  //b
    12: seg=7'b1000110;  //C
    13: seg=7'b0100001;  //d
    14: seg=7'b0000110;  //E
    15: seg=7'b0001110;  //F
   endcase  
endmodule
