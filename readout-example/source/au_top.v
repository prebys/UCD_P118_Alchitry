// This is Alchitry top module to implement the readout module
// discussed in UC Davis P116B "Readout Example Lecture".  
// At the moment, signals are tied to more or less arbitrary pins
// to simulate interaction with the "host".  A few instances 
// of the dummy readout module are instantiated to simulate the
// bus
//
// 13-FEB-2020  E.Prebys  Original
//
module au_top (input clk,
            input START,            // Start scan
            input SEL,              // host select asserted
            input [7:0] HADDR,      // memory address from host
            output BUSY,            // busy if not done scanning
            output [23:0] HDATA,    // data to host
            output [8:0] HNHIT);    // Hit count
// Here are the signals I'll be using to tie the
// internal modules together            
   wire [15:0] DATA;  //data bus
   wire [7:0] ADDR;   //address bus
// Instantiate the readout module
 readout r (.CLK(clk),        // master clock
             .START(START),   // start scan signal from host
             .ADDR(ADDR),     // output from address module
             .DATA(DATA),     // input from ADC module bus
             .SEL(SEL),       // input from host
             .HADDR(HADDR),   // input from host
             .BUSY(BUSY),     // output to host (when selected)
             .HDATA(HDATA),   // output to host (when selected)
             .HNHIT(HNHIT));  // output to host (when selected)
           
// I'm going to hardcode in a few dummy "modules".  These 
// see the ADDR bus as inputs and the DATA bus as outputs 
// I'll hardcode a SLOT and an ADC value for each one
   mod m0 (.slot(0),.ADC(100),.addr(ADDR),.data(DATA));  
   mod m1 (.slot(1),.ADC(2000),.addr(ADDR),.data(DATA)); 
   mod m2 (.slot(2),.ADC(5555),.addr(ADDR),.data(DATA));  
   mod m3 (.slot(3),.ADC(500),.addr(ADDR),.data(DATA));  
//...   
   mod m254 (.slot(254),.ADC(10000),.addr(ADDR),.data(DATA));  
   mod m255 (.slot(255),.ADC(150),.addr(ADDR),.data(DATA));  

           
endmodule