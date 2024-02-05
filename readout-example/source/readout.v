// This implements the readout system described in the 
// UCD P116B "Readout Example" lecture. This module communcates
// with the databus to the ADC modules, and with the "host",
// to which it passes the number of hits and the information
// in the data buffer
//
// 13-FEB-2020 E. Prebys   Original
module readout (
   input CLK,              // synchronous clock
   input START,            // asynchronous start signal
   output ADDR,            // address sent to the data bus
   input [15:0] DATA,      // databus (input to this module)
   input SEL,              // Host select (enables output to host)
   input [7:0] HADDR,      // address to address readout modules
   output BUSY,            // busy sent to host when selected 
   output [23:0] HDATA,    // Data passed to host
   output [8:0] HNHIT);    // Number of hits.  Will be passed to
                           // host if HRD==1. Otherwise Hi-Z
                           
   wire [8:0] NHIT;        // number of hits.  Also serves as address
                           // For data buffer  
   wire RUNNING;           // Asserted when scan is occurring.
   // the memory buffer automatically tri-states the output unless
   // SEL is asserted, but BUSY and HNHIT must be explicitly tri-stated
   assign BUSY = (SEL==1)? RUNNING : 1'bZ;
   assign HNHIT = (SEL==1)? NHIT : 9'h1ZZ;
   
   reg [15:0] THRESH=1000;  // For now, threshold is hardcoded
   reg SS;                  // Synchronous version of START

// synchronize the start signals
   always @(posedge CLK)
     SS=START;     // It's that easy
     
// instantiate the address generator
   address a1 (.clk(CLK),         // input (master clock)
               .ss(SS),           // input 
               .addr(ADDR),       // output to ADC module data bus
               .running(RUNNING));// output to hitcounter module
// instantiate the hitcounter
   hitcounter c1 (.clk(CLK),        // input (master clock)
                  .ss(SS),          // input 
                  .running(RUNNING),// input from address module
                  .data(DATA),      // input from ADC module data bus
                  .thresh(THRESH),  // input (locally hardcoded)
                  .we(WE),          // output to data buffer
                  .nhit(NHIT));     // output to data buffer and host
                  
// instantiate the memory module.  
   buffer b1 (.clk(CLK),            // master clock
                .we(WE),            // input from hitcounter
                .waddr(NHIT[7:0]),  // input from hitcounter
                .wdata({ADDR,DATA}),// input from hitcounter and ADC bus
                .rd(SEL),           // input from host
                .raddr(HADDR),      // input from host
                .rdata(HDATA));     // output to host bus
endmodule
