// 1Hz 24-bit counter
module slowcounter (
    input clk,
    output reg [23:0] count=0);
    
    integer delay=0;
    parameter PERIOD=100000000;  // 100 million cycle period
    
    always @(posedge clk) begin
      delay = delay+1;
      if(delay==PERIOD) begin
        count=count+1;
        delay=0;
      end
    end
    
endmodule
