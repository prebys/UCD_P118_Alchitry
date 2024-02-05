// This code represents a dummy verion of a "readout module"
// In the UC Davis P116B "Readout Example" lecture
//
// 13-FEB-2020  E.Prebys  Original
module mod (
  input [7:0] slot,        // Slot number (hardwired on board)
  input [15:0] ADC,        // Result of ADC
  input [7:0] addr,        // address (from controller)
  output [15:0] data);     // data to bus (tristate but not bi-dir)
  
  assign data=(addr==slot)? ADC: 16'hZZZZ;

endmodule