// slowcounter.v
// -------------
// Solution to P116B lab 5. 1Hz 24bit counter
// Inputs:
//   clk - 100 MHz clock
// Ouputs:
//   count - 24-bit 1Hz count
//
// 11-FEB-2020  E.Prebys  Original


module slowcounter #(parameter WIDTH=24)
    (
    input clk,              // 100 MHz clock
    output reg [WIDTH-1:0] count // WIDTH-bit, 1Hz counter
    );

    integer delay;           // delay clock
    parameter PERIOD=100000000; // 100 million clock period
    
    always @(posedge clk) begin // Advance count every PERIOD 
      delay = delay + 1;        // clock cycles
      if(delay==PERIOD) begin
        count = count+1;
        delay = 0;
      end
    end  
endmodule
