// Simple example to test Alchitry Software and IO board
// 5-JAN-2021  E. Prebys   Original
module au_top_0(
    input clk,              // 100MHz clock
    output [7:0] led,       // 8 user controllable LEDs
    output [23:0] io_led
     );
    
 // Example will just do a slow binary count on LEDs
    reg [23:0] count=0;
    reg [22:0] delay=0;  // Slow 100 MHz Clock to ~10 Hz
    
    assign led=count[7:0];
    assign io_led=count;
    
    always @ (posedge clk) begin
      delay = delay+1;
      if (delay == 0) count = count+1;
    end
      
endmodule        