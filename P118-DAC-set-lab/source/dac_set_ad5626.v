`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Template for the dac setting module for UCD P118 Lab 5.
// Students will only need to modify the code in the indicated area.
// 03-MAR-2021	E.Prebys	Original
// 01-FEB-2024	E.Prebys	Switched the order of sclk and sdin to match
// 							the pinout on the chip
// 10-FEB-2025	E.Prebys	Cleaned up the logic a bit for the start
//
//////////////////////////////////////////////////////////////////////////////////
module dac_set_ad5626 #(parameter DELAY_FACTOR=10) (
  	input clk,           // clk
  	input [11:0] dac,    // 12-bit unsigned DAC value
  	input set,           // strobe to begin write cycle
  	output reg busy=0,   // asserted while writing
  	output reg cs=1,     // chip select, active LO
  	output reg sclk=1,   // serial clock
  	output reg sdin=0,   // serial data
  	output reg ldac=1    // load dac, active LO
    );
    reg [3:0] bit_index=11;     // Pointer to the bit going out
    reg [11:0] dac_register=0;  // Register to hold the DAC value

   	// Set up a five state FSM
    // Five possible states
  	parameter IDLE=0,SCLK_LO=1,SCLK_HI=2,CS_HI=3,LDAC_LO=4;  
  	reg [2:0] state=IDLE;                        // state

  	reg [15:0] delay_counter = 0;                // go slower than the onboard clock

    always @ (posedge clk) begin
      // This is a little tricky.  The SET bit may only be set for one cycle
      // so we'll trick it into starting immediately
      if ((busy==0) && (set == 1)) begin       
        dac_register = dac;            // latch the DAC value
        delay_counter=DELAY_FACTOR-1;  // Force things to start on this cycle
      end
        
      delay_counter = delay_counter+1;    // Only advance the state machine every "delay" clock cycles 
      // The main FSM goes inside this loop
      if (delay_counter>=DELAY_FACTOR) begin
        delay_counter=0;
        //
        // User code goes here...
        //
        case(state)
          // Wait in IDLE state for 'set'
          IDLE: begin
            // Set all the control signals to their ambient state
            cs = 1;
            sdin =0;
            sclk  =1;
            ldac = 1;
            busy = 0;               // busy=FALSE until set
            // Wait for set command
            if (set == 1) begin		
              busy = 1;             // assert busy
              cs = 0;               // assert chip select
              bit_index =11;		// Set pointer to end of data word
              state=SCLK_LO;        // go on to write first bit
            end
          end
          // SCLK_LO state will drive the clock low and assert the current data bit
          SCLK_LO: begin	 
            sclk = 0;			              // drive SCLK low
            sdin = dac_register[bit_index];   // assert data bit
            state = SCLK_HI;                  // go to SCLK high			
          end
          // SCLK_HI will clock in the current data bit		
          SCLK_HI: begin				
            sclk = 1;           
            if(bit_index>0) begin		//  Are we done?	
              bit_index = bit_index-1;  //  Decrement bit_index            
              state = SCLK_LO;          //  write next bit		
            end else begin	
              state = CS_HI;		    // else end write cycle
            end	
          end
          // CS_HI state will clock in the date
          CS_HI: begin
            cs = 1;     
            state = LDAC_LO;            // go on to toggle 'ldac' low
          end   
          // LDAC_LO clocks the data through to the analog output
          LDAC_LO: begin     
            ldac=0;       
            state = IDLE;				// back to IDLE      
          end

        endcase
        // End of user code
      end
    end
endmodule