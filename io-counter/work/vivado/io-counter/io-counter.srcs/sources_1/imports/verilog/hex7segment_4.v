// Hex to 7 segment converter.  Designed to work with the 
// active low 67-2163-1-ND display chip used in the Alchitry Io
// Board
module hex7segment_4(
    input  [3:0]hex,              // 4-bit input
    output reg [6:0]z           // 7-bit output
    );

always @*
case (hex)
  4'b0000 :      	//Hexadecimal 0
  z = 7'b1000000;
  4'b0001 :    		//Hexadecimal 1
  z = 7'b1111001;
  4'b0010 :  		  // Hexadecimal 2
  z = 7'b0100100 ; 
  4'b0011 : 		  // Hexadecimal 3
  z = 7'b0110000 ;
  4'b0100 :		   // Hexadecimal 4
  z = 7'b0011001 ;
  4'b0101 :		   // Hexadecimal 5
  z = 7'b0010010 ;  
  4'b0110 :		   // Hexadecimal 6
  z = 7'b0000010 ;
  4'b0111 :		   // Hexadecimal 7
  z = 7'b1111000;
  4'b1000 :    	 //Hexadecimal 8
  z = 7'b0000000;
  4'b1001 :    	//Hexadecimal 9
  z = 7'b0010000 ;
  4'b1010 :  		// Hexadecimal A
  z = 7'b0001000 ; 
  4'b1011 : 		// Hexadecimal B
  z = 7'b0000011;
  4'b1100 :		  // Hexadecimal C
  z = 7'b1000110 ;
  4'b1101 :		  // Hexadecimal D
  z = 7'b0100001 ;
  4'b1110 :		  // Hexadecimal E
  z = 7'b0000110 ;
  4'b1111 :		  // Hexadecimal F
  z = 7'b0001110 ;
endcase
   
endmodule
