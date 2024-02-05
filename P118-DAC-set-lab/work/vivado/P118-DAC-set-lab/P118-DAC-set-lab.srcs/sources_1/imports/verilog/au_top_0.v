// This is a simple program to write a ramp to the 12 bit DAC from the Alchitry-Au.
// DAC setting will be displayed on the lower 12 bits of the io_leds and (in decimal) on the segment
// displays.
//
// Inputs:
//    clk             - 100 MHz clk
//    io_dip[23:0]    - Dip settings:
//                        23   - MODE bit: 1-> ramp DAC setting
//                                         0-> use value on bits 11:0
//                        22   - SPEED bit:  0 = 100 Hz
//                                           1 = 100 kHz
//                        11:0  - If MODE==0, these bits are loaded to the DAC
// Outputs:
//    led[7:0]        - 8 MSB of the DAC setting
//    io_led[23:0]    - 23:12: state of dip switches 23:12
//                      11:0:  DAC setting
//    UCD_io[4:0]     - general purpose IO pins to control the DAC, as defined below
//    io_sel[3:0]     - segment digit select
//    io_seg[7:0]     - segment driver bits
//
// 26-JAN-2021  EjP   Original
// 25-MAR-2021  EjP   Working after lots of tweaks and changes
// 05-DEB-2024  EjP   Changed the order of SDIN and SLCK to match the pinout
// 

module au_top_0(
    input clk,              // 100MHz clock
    input  [23:0] io_dip,   // Dip switches
    output [23:0] io_led,   // 24 user controllable LEDs on the Alchitry-Io board
    output [4:0] UCD_io,    // Use 5 of six user bits on the custom UCD Alchitry-Br board
    output [3:0] io_sel,    // Display digit slecet
    output [7:0] io_seg     // Segment driver bits
    );
wire cs,sclk,sdin,ldac,mode,speed;
assign UCD_io[0]=cs;          // DAC chip select, active low
assign UCD_io[1]=sclk;        // Serial clock
assign UCD_io[2]=sdin;        // Serial data bit
assign UCD_io[3]=ldac;        // load DAC bit, active low
assign UCD_io[4]=1;           // CLR, active low.  Must tie hi!!
assign mode=io_dip[23];       // 0=use DIP to set DAC, 1=use counter
assign speed=io_dip[22];      // 0=100Hz, 1=100 kHz

// create a wire for the dac setting
wire  [11:0] dac;
assign io_led[11:0]=dac[11:0];           // die the dac setting to the LEDs
assign io_led[23:12]=io_dip[23:12];      // just tie the upper LEDs to the upper DIPs
wire busy;

// Increment the counter and issue the set bit according to speed
wire [11:0] counter;
wire set;
slowcount_1 c1(clk,speed,set,counter);
assign dac=(mode==0)? io_dip:counter;

 
// Set the DAC with the current value of dac[11:0].
dac_set_ad5626_2 da(.clk(clk),
                    .dac(dac),
                    .set(set),			// start write
                    .busy(),		// busy=1 during write
                    .cs(cs),			// cs (to DAC)
                    .sclk(sclk),        // Serial clock (to DAC)
                    .sdin(sdin),        // Serial DATA (to DAC)
                    .ldac(ldac));		// DAC load bit

//Display the DAC calue on the 7 segment digits
wire [19:0] bcd;  //BCD display bytes
hex2bcd_3 h1 ({4'b000,dac},bcd);            // Convert DAC to BCD
fourhexdisplay_4 f1 (clk,bcd[15:0],io_sel,io_seg); // Display BCD bytes

endmodule