// Readout buffer used in "Readout Example" lecture in
// UC Davis P116B.
//
// 13-FEB-2020  E.Prebys  Original
//
module buffer #(parameter DATBITS=24, ADDBITS=8) 
   (
   input clk,    // synchonous write clock to left side
   input we,     // synchronous left write enable
   input [ADDBITS-1:0] waddr,  // write address
   input [DATBITS-1:0] wdata,  // WRITE DATA
   input rd,     // read enable
   input [ADDBITS-1:0] raddr,  // read address
   output [DATBITS-1:0] rdata);// read databus 

// reserve memory space.  The size should be 2**ADBITS words,
// each of which are DATBITS wide 
 
   reg [DATBITS-1:0] mem [2**ADDBITS-1:0];  // Set aside memory space
   
// Readout is asynchronous.  If rd==1, assert data, else hi-Z
   assign rdata = (rd==1)? mem[raddr]: {DATBITS*{1'bZ}};
   
// Synchronously clock in data from the left if we is set
   always @(posedge clk) 
      if(we==1) mem[waddr]=wdata;
   
  
endmodule
