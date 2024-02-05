//////////////////////////////////////////////////////////////////////////////////
// Company:        UC Davis
// Engineer:       Eric Prebys
// 
// Create Date:    26-JAN-2021 
// Design Name:    P116B Lab 7
// Module Name:    dac_set_ad2626 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This routine will set the 12 bit serial dac that comes with the ADALP2000 accessory kit.  It's based on a previous
//              routine to set the DAC on the old Spartan 3 development board.
//   Parameters:
//      DELAY_FACTOR    - factor to slow down the clock (defaults to 10)
//   Inputs:
//      clk             - Onboard 100 MHz clock
//      dac[11:0]       - 12 bit dac setting word
//      set             - write cycle begins when SET goes HI
//   Outputs:
//      (to main module)
//      busy           - Goes HI while write is in progress
//      (to DAC pins)
//      cs              - Goes LO to start write cycle
//      sclk            - serial clock
//      sdin            - serial data bits, MSB first
//      ldac            - load dac values
//   Note!  In addition to these bits, the DAC_CLR pin must be held
//   HI to prevent the DAC from being held in a reset state!     
//
// Dependencies: 
//
// Revision: 
//          1.00 - EjP, 20210126  Created, based on previous DAC_SET module
//          1.10 - EjP, 20240205  Changed order of SDIN and SCLK to match pinout
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dac_set_ad5626 #(parameter DELAY_FACTOR=10) (
  	input clk,           // clk
  	input [11:0] dac,    // 12-bit unsigned DAC value
  	input set,           // strobe to begin write cycle
  	output reg busy=0,   // asserted while writing
  	output reg cs=1,     // chip select, active LO
  	output reg sclk=0,   // serial clock
  	output reg sdin=0,   // serial data
  	output reg ldac=1    // load dac, active LO
    );
    reg [3:0] bit_index=11;  // Pointer to the bit going out
    reg [11:0] dac_register=0;  // Register to hold the DAC value

   	// Set up a five state FSM
  	parameter IDLE=0,SCLK_LO=1,SCLK_HI=2,CS_HI=3,LDAC_LO=4;  // Five possible states
 	  reg [2:0] state=IDLE;                          // state

  	reg [15:0] delay_counter = 0;                  // go slower than the onboard clock

    always @ (posedge clk) begin
        // We're only going to advance things every "delay" clock cycles, but it's important to latch the
        // "set" bit and immediately assert "busy"
        //
        if ((busy==0) && (set == 1)) begin 
           dac_register=dac;// strobe in the DAC value
           busy=1;          // immediately assert busy.  This will signal you to move out of IDLE
           delay_counter=0; // just to get us always on the same page
        end
        delay_counter = delay_counter+1;    // Only advance the state machine every "delay" clock cycles
        if (delay_counter>=DELAY_FACTOR) begin
         	delay_counter=0;
	     	  case(state)
		      	IDLE: begin						// Wait for "start_write" command (latched from "set")
				      cs = 1;
    			    sdin =0;
					    sclk  =0;
              ldac = 1;
              if (busy == 1) begin		//  If set bit has been asserted, assert busy, go to clock lo
						      cs = 0;
                 bit_index =11;			// Set pointer to end of data word
				    	    state=SCLK_LO;
					    end
				    end
				    SCLK_LO: begin					// assert next data bit
				  	  sclk = 0;
				  	  sdin = dac_register[bit_index];
				  	  state = SCLK_HI;
				    end
				    SCLK_HI: begin					// sclk hi
				  	  sclk = 1;
              if(bit_index>0) begin		//  Are we done?
				    	    bit_index = bit_index-1;//  Decrement bit_index
                  state = SCLK_LO;
				  	  end else begin
				    	    state = CS_HI;
				  	  end
				    end
           CS_HI: begin					  // Bring CS back HI to finish write cycle.
             cs = 1;
             state = LDAC_LO;
           end
           LDAC_LO: begin					// ldac lo to toggle in data
             ldac=0;
             busy=0;
             state = IDLE;				// back to IDLE
           end
			endcase
    end
	end

endmodule

