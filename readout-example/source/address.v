// Address generator discussed on "Readout Example" lecture
// of UC Davis P116B.  In response to a synchronous ss
// signal, it will generate addresses from 0-255 and also
// assert a "running" status which the addresses are valid.
//
// 13-FEB-2020  E. Prebys  Original
//
module address (
  input clk,              // synchronous clock
  input ss,               // synchonous start
  output reg [7:0] addr,  // address
  output reg running);    // asserted while cycling through addresses
  
  parameter IDLE=0, RUN=1;  // Define the states
  integer state=IDLE;       // state word, initialized to IDLE
  
  // Increment the address in a simple state machine
  always @(posedge clk) begin // operation entirely synchronous
    case(state) 
      IDLE: begin             // sit in the IDLE state until we get an
        if (ss==0) 
          running = 0;          
        else begin
          running = 1;
          addr = 0;
          state = RUN;        // This will be the state on the NEXT cycle
        end
        end
      RUN: begin              // If it's running, then increment the address
        addr = addr+1;
        if (addr==255)        // if this is the last address, go back to idle on
           state = IDLE;      // next cycle
       end
     
     endcase
   end
        
endmodule
