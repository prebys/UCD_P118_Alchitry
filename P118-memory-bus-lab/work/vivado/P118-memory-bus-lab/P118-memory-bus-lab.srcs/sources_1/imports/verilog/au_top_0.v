module au_top_0(
    input clk,
    input [23:0] io_dip,
    input [4:0] io_button,
    output [23:0] io_led,
    output [3:0] io_sel,
    output [7:0] io_seg);
    
    wire [7:0] databus;
    wire [3:0] address;
    wire rd;
    wire wr;
    wire mode;
    
    assign wr=io_button[0];
    assign mode=io_dip[23];
    assign rd=io_button[1]|mode;
    
    wire [15:0] displaybits;
    wire [23:0] count;
    
    assign displaybits={4'h0,address,databus};
    
    assign address=(mode==0)? io_dip[11:8]: count[3:0];
    
    // Tie everything depending on the state of the switches
    
    assign databus = (rd==0)? io_dip[7:0]: 8'hZZ;
    
    // instatiate the counter and the memory module
    slowcounter_1 c1 (.clk(clk),.count(count));
    binary2display_2 d1 (.clk(clk),
                       .data(displaybits),
                       .sel(io_sel),
                       .seg(io_seg));
    memory_3 m1 (.databus(databus),
               .address(address),
               .rd(rd),
               .wr(wr));  
             
endmodule