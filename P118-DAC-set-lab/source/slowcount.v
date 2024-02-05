// Counter to count in to moodes
//  speed = 0: clk/SLOWFACTOR, default 100 Hz
//        = 1: clk/FASTFACTOR, default 100 kHz
// Parameters:
//    FASTFACTOR:  Clock division factor for fast clock, default=1000 (100 kHz)
//    SLOWFACTOR:  Clock division factor for slow clock, defualt=1000000 (100 Hz)
// Inputs:
//    clk:   100 MHz systen clock
//    speed:  which speed to use, described above
// Oututs:
//    set:            issued for one cycle every time counter updates
//    counter[11:0]:  12-bit counter
//
// 25-MAR-2021  EjP  Original
//
module slowcount #(parameter FASTFACTOR=1000, parameter SLOWFACTOR=1000000) (
  input clk,        // 100 MHz clock
  input speed,      // 0 = use SHORTDELAY, 
  output reg set,   // issued whenever the counter is incremented
  output reg [11:0] counter=0);  // slowed down set bit

 integer delay=0;  

  wire [31:0] FACTOR;
  assign FACTOR=(speed==0)? SLOWFACTOR:FASTFACTOR;
  
 always @( posedge clk) begin
    delay=delay+1;
    set=0;
   if(delay>=FACTOR) begin
      counter=counter+1;
      set=1;
      delay=0;
    end
 end
  
endmodule
