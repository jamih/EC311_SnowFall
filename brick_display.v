`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2020 11:11:25 AM
// Design Name: 
// Module Name: brick_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module brick_display(

    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [3:0] VGA_R,    // 4-bit VGA red output
    output wire [3:0] VGA_G,    // 4-bit VGA green output
    output wire [3:0] VGA_B     // 4-bit VGA blue output
    );

    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
    

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );

    // Four overlapping squares
    wire 
    
redRow1,
redRow2, 
redRow3, 
redRow4, 
redRow5,        
redRow6, 
redRow7, 
redRow8, 
redRow9, 
redRow10,      
redRow11, 
redRow12,
redRow13,
redRow14,
redRow15,       
redRow16,
redRow17,
redRow18,
redRow19,
redRow20,
greenRow1,
greenRow2, 
greenRow3, 
greenRow4, 
greenRow5,        
greenRow6, 
greenRow7, 
greenRow8, 
greenRow9, 
greenRow10,      
greenRow11, 
greenRow12,
greenRow13,
greenRow14,
greenRow15,       
greenRow16,
greenRow17,
greenRow18,
greenRow19,
greenRow20;
    // red rects
    assign redRow1 =  ((x > 100) & (y > 60) & (x < 140) & (y < 80)) ? 1 : 0;  
    assign redRow2 =  ((x > 180) & (y > 60) & (x < 220) & (y < 80)) ? 1 : 0; 
    assign redRow3 =  ((x > 260) & (y > 60) & (x < 300) & (y < 80)) ? 1 : 0; 
    assign redRow4 =  ((x > 340) & (y > 60) & (x < 380) & (y < 80)) ? 1 : 0; 
    assign redRow5 =  ((x > 420) & (y > 60) & (x < 460) & (y < 80)) ? 1 : 0; 
    
    assign redRow6 =  ((x > 140) & (y > 80) & (x < 180) & (y < 100)) ? 1 : 0; 
    assign redRow7 =  ((x > 220) & (y > 80) & (x < 260) & (y < 100)) ? 1 : 0; 
    assign redRow8 =  ((x > 300) & (y > 80) & (x < 340) & (y < 100)) ? 1 : 0; 
    assign redRow9 =  ((x > 380) & (y > 80) & (x < 420) & (y < 100)) ? 1 : 0; 
    assign redRow10 = ((x > 460) & (y > 80) & (x < 500) & (y < 100)) ? 1 : 0; 
    
   assign redRow11 =  ((x > 100) & (y > 100) & (x < 140) & (y < 120)) ? 1 : 0; 
    assign redRow12 = ((x > 180) & (y > 100) & (x < 220) & (y < 120)) ? 1 : 0; 
    assign redRow13 = ((x > 260) & (y > 100) & (x < 300) & (y < 120)) ? 1 : 0; 
    assign redRow14 = ((x > 340) & (y > 100) & (x < 380) & (y < 120)) ? 1 : 0; 
    assign redRow15 = ((x > 420) & (y > 100) & (x < 460) & (y < 120)) ? 1 : 0; 
    
    assign redRow16 = ((x > 140) & (y > 120) & (x < 180) & (y < 140)) ? 1 : 0; 
    assign redRow17 = ((x > 220) & (y > 120) & (x < 260) & (y < 140)) ? 1 : 0; 
    assign redRow18 = ((x > 300) & (y > 120) & (x < 340) & (y < 140)) ? 1 : 0; 
    assign redRow19 = ((x > 380) & (y > 120) & (x < 420) & (y < 140)) ? 1 : 0; 
    assign redRow20 = ((x > 460) & (y > 120) & (x < 500) & (y < 140)) ? 1 : 0; 
    
    
    // green rects 
     assign greenRow1=  ((x > 140) & (y > 60) & (x < 180) & (y < 80)) ? 1 : 0; 
     assign greenRow2=  ((x > 220) & (y > 60) & (x < 260) & (y < 80)) ? 1 : 0; 
     assign greenRow3=  ((x > 300) & (y > 60) & (x < 340) & (y < 80)) ? 1 : 0; 
     assign greenRow4=  ((x > 380) & (y > 60) & (x < 420) & (y < 80)) ? 1 : 0; 
     assign greenRow5=  ((x > 460) & (y > 60) & (x < 500) & (y < 80)) ? 1 : 0;
     
    assign greenRow6   = ((x > 100) & (y > 80) & (x < 140) & (y < 100)) ? 1 : 0; 
    assign greenRow7   = ((x > 180) & (y > 80) & (x < 220) & (y < 100)) ? 1 : 0; 
    assign greenRow8   = ((x > 260) & (y > 80) & (x < 300) & (y < 100)) ? 1 : 0; 
    assign greenRow9   = ((x > 340) & (y > 80) & (x < 380) & (y < 100)) ? 1 : 0; 
    assign greenRow10  = ((x > 420) & (y > 80) & (x < 460) & (y < 100)) ? 1 : 0; 
    
    assign greenRow11 = ((x > 140) & (y > 100) & (x < 180) & (y < 120)) ? 1 : 0; 
    assign greenRow12 = ((x > 220) & (y > 100) & (x < 260) & (y < 120)) ? 1 : 0; 
    assign greenRow13 = ((x > 300) & (y > 100) & (x < 340) & (y < 120)) ? 1 : 0; 
    assign greenRow14 = ((x > 380) & (y > 100) & (x < 420) & (y < 120)) ? 1 : 0; 
    assign greenRow15 = ((x > 460) & (y > 100) & (x < 500) & (y < 120)) ? 1 : 0; 
    
     assign greenRow16= ((x > 100) & (y > 120) & (x < 140) & (y < 140)) ? 1 : 0; 
     assign greenRow17= ((x > 180) & (y > 120) & (x < 220) & (y < 140)) ? 1 : 0; 
     assign greenRow18= ((x > 260) & (y > 120) & (x < 300) & (y < 140)) ? 1 : 0; 
     assign greenRow19= ((x > 340) & (y > 120) & (x < 380) & (y < 140)) ? 1 : 0; 
     assign greenRow20= ((x > 420) & (y > 120) & (x < 460) & (y < 140)) ? 1 : 0;
     
     
     
    
    
    
    

    assign VGA_R[3] = 
    redRow1 +
    redRow2 +
    redRow3  +
    redRow4  +
    redRow5  +  
    redRow6  +
    redRow7  +
    redRow8  +
    redRow9  +
    redRow10 +
    redRow11 +
    redRow12 +
    redRow13 +
    redRow14 +
    redRow15 +
    redRow16 +
    redRow17 +
    redRow18 +
    redRow19 +
    redRow20;

    assign VGA_G[3] =
    greenRow1 +
    greenRow2 +
    greenRow3  +
    greenRow4  +
    greenRow5  +  
    greenRow6  +
    greenRow7  +
    greenRow8  +
    greenRow9  +
    greenRow10 +
    greenRow11 +
    greenRow12 +
    greenRow13 +
    greenRow14 +
    greenRow15 +
    greenRow16 +
    greenRow17 +
    greenRow18 +
    greenRow19 +
    greenRow20;
    
    
endmodule