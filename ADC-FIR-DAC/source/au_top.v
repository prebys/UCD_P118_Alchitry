// This is a simple program to test a simple FIR filter, implemented with the IP Catalog in Vivado.
// It reads in an analog value from the V+ and V- inputs on the internal XADC, filters them through a 
// FIR filter built with the IP Catalog Wizard, then writes the result to a serial 12-bit AD5626 DAC
// using the custom UC Davis Alchitry-Br board.
//
// 24-JAN-2021  EjP  Working version, after a lot of false starts
// 

module au_top(
    input clk,              // 100MHz clock
    input vp_in,            // dedicated analog input (+)
    input vn_in,            // dedicated analog input (-)
    output [4:0] UCD_io     // custom UCD io pins
        );
    // the user bits are tied to pins on the DAC
    wire cs,sclk,sdin,ldac;
    assign UCD_io[0]=cs;          // chip select, active low
    assign UCD_io[1]=sclk;        // Serial clock
    assign UCD_io[2]=sdin;        // Serial data bit
    assign UCD_io[3]=ldac;        // load DAC bit, active low
    assign UCD_io[4]=1;           // clr, active low (tie high)
  
    
 
 
 // The following code will read out the XADC digitization of AVP-AVN and display the 12 MSBs in decimal
    wire [11:0] XADC_value;
    wire [11:0] DAC_value;
 
  // Set up delay to reduce the clock to the sample rate
    parameter SAMPLE_FACTOR=2000;      // Sample at 100 MHz/2000=50 kHz
    integer sample_delay=0;            // counter to count this delay
    
    reg strobe=0;         // One strobe to rule them all: ADC, FIR, and DAC

    always @ (posedge clk) begin  // This block produces the sample rate strobe
      sample_delay=sample_delay+1;
      strobe=0;
      if (sample_delay==SAMPLE_FACTOR) begin
         strobe=1;                // This will be asserted at 100MHz/SAMPLE_FACTOR
         sample_delay=0;
      end
    end           

    // Wrapper around the XADC stub created by the Vivado IP Wizard    
    xadc_wrapper x1 (.clk(clk),           // System clock
                     .convst(strobe),     // conversion strobe
                     .vp_in(vp_in),       // V+ in
                     .vn_in(vn_in),       // V- in (GND externally)
                     .busy(),             // assume we're running slower than conversion
                     .XADC_value(XADC_value));  // output

    // Instantiate the serial DAC encoder module
    dac_set_ad5626 da(.clk(clk),         // system clock
                    .dac(DAC_value),     // The DAC value
                    .set(strobe),			    // start write
                    .busy(),		          // busy=1 during write
                    .cs(cs),			        // cs (to DAC)
                    .sdin(sdin),          // Serial DATA (to DAC)
                    .sclk(sclk),          // Serial clock (to DAC)
                    .ldac(ldac));		       // DAC load bit    
      
   wire [31:0] m_axis_data_tdata;              // output of FIR filter

 // Instantiate FIR filter
   fir_compiler_0 your_instance_name (
      .aclk(clk),                              // input wire aclk
      .s_axis_data_tvalid(strobe),             // input wire s_axis_data_tvalid
      .s_axis_data_tready(),                   // output wire s_axis_data_tready
      .s_axis_data_tdata({4'b000,XADC_value}),          // input wire [15 : 0] s_axis_data_tdata
      .m_axis_data_tvalid(),                   // output wire m_axis_data_tvalid
      .m_axis_data_tdata(m_axis_data_tdata));    // output wire [31 : 0] m_axis_data_tdata 

  // pass data through FIR filter
   assign DAC_value=m_axis_data_tdata[27:16]+12'h800;  // Divide by two and add 2^11
endmodule        