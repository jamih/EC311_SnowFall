`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Thomas Kappenman
// 
// Create Date: 03/03/2015 09:06:31 PM
// Design Name: 
// Module Name: top
// Project Name: Nexys4DDR Keyboard Demo
// Target Devices: Nexys4DDR
// Tool Versions: 
// Description: This project takes keyboard input from the PS2 port,
//  and outputs the keyboard scan code to the 7 segment display on the board.
//  The scan code is shifted left 2 characters each time a new code is
//  read.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK100MHZ,
  // input CLK,
   input wire RST_BTN,         // reset button
    input PS2_CLK,
    input PS2_DATA,
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output UART_TXD,
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [3:0] VGA_R,    // 4-bit VGA red output
    output wire [3:0] VGA_G,    // 4-bit VGA green output
    output wire [3:0] VGA_B    // 4-bit VGA blue output

    );
     wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
     parameter MAX_COUNT = 1_000_000 - 1;
     reg [26:0] counter_100M;
     wire    counter_en;

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK100MHZ)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

   vga640x480 display (
        .i_clk(CLK100MHZ),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );
    

reg CLK50MHZ=0;    
wire [31:0]keycode;

always @(posedge(CLK100MHZ))begin
    CLK50MHZ<=~CLK50MHZ;
end

PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.keycodeout(keycode[31:0])
);

seg7decimal sevenSeg (
.x(keycode[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(DP) 
);


 reg[9:0] xPos = 20;
   wire paddle;
    
      always @(posedge CLK100MHZ)
       begin
      if(counter_100M == MAX_COUNT)
            counter_100M <=0;
        else
            counter_100M <= counter_100M + 1'b1;
     end
    
    assign counter_en = counter_100M == 0;
    
    // draw the initial paddle rectangle
 
    always@(posedge CLK100MHZ)
     begin
        if(counter_en)
            if (keycode[7:0] == 8'h1C)
                if(xPos == 20)
                    xPos = 20;
                else
                    xPos = xPos -1;
        
        else if (keycode[7:0] == 8'h23)
            if(xPos == 600)
                xPos = 600;
            else
                 xPos = xPos + 1;
  
       end
        

       assign paddle =  ((x > xPos-20 ) & (y > 450) & (x < xPos +20) & (y < 460)) ? 1 : 0;
       
       assign VGA_R[3] = paddle;
       assign VGA_G[3] = paddle;
       assign VGA_B[3] = paddle;
        
 
endmodule
