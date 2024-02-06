// Simple memory module with 16 8-bit
// locations
module memory_3 (
  inout [7:0] databus,
  input [3:0] address,
  input rd,
  input wr);
  
  reg [7:0] mem [15:0];
  
  assign databus = (rd==1)? mem[address] : 8'hZZ;
  
  always @(wr) 
    if(wr==1) mem[address]=databus;
  
endmodule
