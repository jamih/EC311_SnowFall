`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2020 12:06:15 AM
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
    input wire RST_BTN,   
    input PS2_CLK,
    input PS2_DATA,      // reset button
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output reg [3:0] VGA_R,    // 4-bit VGA red output
    output reg [3:0] VGA_G,    // 4-bit VGA green output
    output reg [3:0] VGA_B,   // 4-bit VGA blue output
    output wire [7:0] Anode_Activate, // anode signals of the 7-segment LED display
    output wire [6:0] LED_out, // cathode patterns of the 7-segment LED display
    output reg [7:0] score,
    output wire speaker
    );

    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
//    reg [15:0] score;
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

    // make millisecond clock
     parameter MAX_COUNT = 1_000_000 - 1;
     parameter MAX_PADDLE = 500_000 - 1;
     reg [26:0] counter_1M, counter_500M;
     wire counter_en, counter_paddle;
     
     always @(posedge CLK)
       begin
      if(counter_1M == MAX_COUNT)
            counter_1M <=0;
        else
            counter_1M <= counter_1M + 1'b1;
     end
     
    assign counter_en = counter_1M == 0;
    
    always @(posedge CLK)
       begin
      if(counter_500M == MAX_PADDLE)
            counter_500M <=0;
        else
            counter_500M <= counter_500M + 1'b1;
     end
     
    assign counter_paddle = counter_500M == 0;
    
    // make 1-second clock
     parameter MAX_COUNT1 = 100_000_000 - 1;
     reg [26:0] counter_100M;
     wire counter_en1;
     
     always @(posedge CLK)
       begin
      if(counter_100M == MAX_COUNT1)
            counter_100M <=0;
        else
            counter_100M <= counter_100M + 1'b1;
     end
     
    assign counter_en1 = counter_100M == 0;
    
    reg [6:0] seconds = 90;
    reg enter = 0;

    always @(posedge CLK) begin
    if (counter_en1 && enter == 1)
                if(seconds > 0)
                    seconds <= seconds - 1'b1;
                 if(seconds == 0 && enter == 0) begin
                    seconds = 90;
                 end
    end

    
    wire paddleGreen;
    wire paddleRed;
    wire paddleBlue;
    wire vgah;
    wire vgav;
    
    top Top(.clk(CLK), .speaker(speaker));

    reg CLK50MHZ=0;    
    wire [31:0]keycode;
    
    always @(posedge(CLK))begin
        CLK50MHZ<=~CLK50MHZ;
    end
    
    PS2Receiver keyboard (
    .clk(CLK50MHZ),
    .kclk(PS2_CLK),
    .kdata(PS2_DATA),
    .keycodeout(keycode[31:0])
    );


 reg[9:0] xPos = 20;
 wire paddle;
    
    /*
      always @(posedge CLK100MHZ)
       begin
      if(counter_100M == MAX_COUNT)
            counter_100M <=0;
        else
            counter_100M <= counter_100M + 1'b1;
     end
    
    assign counter_en = counter_100M == 0;
    */
    
    // draw the initial paddle rectangle
 
 
    reg [1:0] pSpeed = 1;
    always @(posedge CLK) begin
        if (score >= impossible)
        pSpeed = 2;
    end
    
    always@(posedge CLK)
     begin
        if(counter_paddle)
            if (keycode[7:0] == 8'h6b)
                if(xPos <= 20)
                    xPos = 600;
                else
                    xPos = xPos - pSpeed;
        
        else if (keycode[7:0] == 8'h74)
            if(xPos >= 600)
                xPos = 20;
            else
                 xPos = xPos + pSpeed;
       end
        

       assign paddle =  ((x > xPos-20 ) & (y > 450) & (x < xPos +20) & (y < 460)) ? 1 : 0;
       
       /*
       assign VGA_R[3] = paddle;
       assign VGA_G[3] = paddle;
       assign VGA_B[3] = paddle;
       */

    wire brick1, brick2, brick3, brick4, brick5, brick6, brick7, brick8, brick9, brick10;
    wire bomb1, bomb2, bomb3, bomb4, bomb5, bomb6, bomb7, bomb8;
    
    reg [9:0] yPos1 = 0;
    reg [9:0] yPos2 = 0;
    reg [9:0] yPos3 = 0;
    reg [9:0] yPos4 = 0;
    reg [9:0] yPos5 = 0;
    reg [9:0] yPos6 = 0;
    reg [9:0] yPos7 = 0;
    reg [9:0] yPos8 = 0;
    reg [9:0] yPos9 = 0;
    reg [9:0] yPos10 = 0;
    
    reg [9:0] ybPos1 = 0;
    reg [9:0] ybPos2 = 0;
    reg [9:0] ybPos3 = 0;
    reg [9:0] ybPos4 = 0;
    reg [9:0] ybPos5 = 0;
    reg [9:0] ybPos6 = 0;
    reg [9:0] ybPos7 = 0;
    reg [9:0] ybPos8 = 0;
    reg [9:0] ybPos9 = 0;

    
    //generate random number using LFSR
    reg [3:0] currentNum;
    reg [3:0] bombNum;
    wire [3:0] num;
    wire [3:0] num2;
    wire [3:0] out;
    reg start = 1;
    reg s = 0;
    reg [3:0] impossible = 10;
    reg [5:0] score = 0;
    
    //change rst to one after one second
    
    always @(posedge CLK) begin
        if (counter_en1) begin
            s <= s + 1;
        end
        if (s > 0) begin
            start = 0; //blocks begin falling when start = 0, (after 1 second)
        end
    end
    
    always @(posedge CLK) begin
        if (keycode[7:0] == 8'h5A)
            enter = 1;
        if (keycode[7:0] == 8'h1C)
            enter = 0;
    end

    lfsr L(.num(num), .out(out), .clk(CLK), .rst(start));
    lfsr L2(.num(num2), .out(out2), .clk(counter_en), .rst(start));
    
    always @(posedge CLK) begin
        if (counter_en1) begin
            currentNum <= num;
            bombNum <= num2;
        end
    end

    always @(posedge CLK) begin
        if (counter_en1) begin
            currentNum <= num;
        end
    end
            
    reg [2:0] speed = 1;
    reg [1:0] lostHeart = 0;
    reg death = 0;
    wire heart1, heart2, heart3;
    always @(posedge CLK) begin
        if (score >= impossible)
        speed = 2;
    end
    
    //Drop random block
    always @(posedge CLK)
    begin
    if (counter_en) begin
        
        if(enter == 0)
            score = 0;
    
        if(currentNum == 0 && yPos1 == 0) 
            yPos1 <= yPos1 + 1;
        if (yPos1 >= 1)
            yPos1 <= yPos1 + speed;
        if (yPos1 >= 470) begin
            yPos1 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>01 && xPos<61 && yPos1>=440 && yPos1<=445) begin
            score <= score + 1;
            yPos1 <= 0;
        end
        
             
            
        if(currentNum == 1 && yPos2 == 0) 
            yPos2 <= yPos2 + 1;
        if (yPos2 >= 1)
            yPos2 <= yPos2 + speed;
        if (yPos2 >= 470) begin
            yPos2 <= 0;
        end
        if(xPos>63 && xPos<123 && yPos2>=440 && yPos2<=445) begin
            score <= score + 1;
            yPos2 <= 0;
        end
        
        if(currentNum == 2 && yPos3 == 0) 
            yPos3 <= yPos3 + 1;
        if (yPos3 >= 1)
            yPos3 <= yPos3 + speed;
        if (yPos3 >= 470) begin
            yPos3 <= 0;
        end
        if(xPos>125 && xPos<185 && yPos3>=440 && yPos3<=445) begin
            score <= score + 1;
            yPos3 <= 0;
        end
        
        if(currentNum == 3 && yPos4 == 0) 
            yPos4 <= yPos4 + 1;
        if (yPos4 >= 4)
            yPos4 <= yPos4 + speed;
        if (yPos4 >= 470) begin
            yPos4 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>187 && xPos<247 && yPos4>=440 && yPos4<=445) begin
            score <= score + 1;
            yPos4 <= 0;
        end
        
        if(currentNum == 4 && yPos5 == 0) 
            yPos5 <= yPos5 + 1;
        if (yPos5 >= 1)
            yPos5 <= yPos5 + speed;
        if (yPos5 >= 470) begin
            yPos5 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>249 && xPos<309 && yPos5>=440 && yPos5<=445) begin
            score <= score + 1;
            yPos5 <= 0;
        end
        
        if(currentNum == 5 && yPos6 == 0) 
            yPos6 <= yPos6 + 1;
        if (yPos6 >= 1)
            yPos6 <= yPos6 + speed;
        if (yPos6 >= 470) begin
            yPos6 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>311 && xPos<371 && yPos6>=440 && yPos6<=445) begin
            score <= score + 1;
            yPos6 <= 0;
        end
        
        if(currentNum == 6 && yPos7 == 0) 
            yPos7 <= yPos7 + 1;
        if (yPos7 >= 1)
            yPos7 <= yPos7 + speed;
        if (yPos7 >= 470) begin
            yPos7 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>373 && xPos<433 && yPos7>=440 && yPos7<=445) begin
            score <= score + 1;
            yPos7 <= 0;
        end
        
        if(currentNum == 7 && yPos8 == 0) 
            yPos8 <= yPos8 + 1;
        if (yPos8 >= 1)
            yPos8 <= yPos8 + speed;
        if (yPos8 >= 470) begin
            yPos8 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>435 && xPos<495 && yPos8>=440 && yPos8<=445) begin
            score <= score + 1;
            yPos8 <= 0;
        end
        
        if(currentNum == 8 && yPos9 == 0) 
            yPos9 <= yPos9 + 1;
        if (yPos9 >= 1)
            yPos9 <= yPos9 + speed;
        if (yPos9 >= 470) begin
            yPos9 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>497 && xPos<557 && yPos9>=440 && yPos9<=445) begin
            score <= score + 1;
            yPos9 <= 0;
        end
        
        if(currentNum == 9 && yPos10 == 0) 
            yPos10 <= yPos10 + 1;
        if (yPos10 >= 1)
            yPos10 <= yPos10 + speed;
        if (yPos10 >= 470) begin
            yPos10 <= 0;
            lostHeart <= lostHeart + 1;
        end
        if(xPos>558 && xPos<618 && yPos10>=440 && yPos10<=445) begin
            score <= score + 1;
            yPos10 <= 0;
        end
        
        ////////////////////////////////BOMBS!!!!!!!!!!!!!!/////////////////////////////////////////////
        
        if(bombNum == 0 && ybPos1 == 0 && seconds <= 40) 
            ybPos1 <= ybPos1 + 1;
        if (ybPos1 >= 1) 
            ybPos1 <= ybPos1 + speed*2;
        if (ybPos1 >= 480) 
            ybPos1 <= 0; 
        if(xPos>31 && xPos<91 && ybPos1>=440 && ybPos1<=445) begin
            score <= score - 1;
            ybPos1 <= 0;
        end
             
        if(bombNum == 1 && ybPos2 == 0 && score >= impossible)
            ybPos2 <= ybPos2 + 1;
        if (ybPos2 >= 1)
        
            ybPos2 <= ybPos2 + speed*2;
        if (ybPos2 >= 480)
            ybPos2 <= 0;
        if(xPos>93 && xPos<153 && ybPos2>=440 && ybPos2<=445) begin
            score <= score - 1;
            ybPos2 <= 0;
        end
        
        if(bombNum == 2 && ybPos3 == 0 && score >= impossible) 
            ybPos3 <= ybPos3 + 1;
        if (ybPos3 >= 1)
            ybPos3 <= ybPos3 + speed*2;
        if (ybPos3 >= 480)
            ybPos3 <= 0;
        if(xPos>155 && xPos<215 && ybPos3>=440 && ybPos3<=445) begin
            score <= score - 1;
            ybPos3 <= 0;
        end
        
        if(bombNum == 3 && ybPos4 == 0 && score >= impossible) 
            ybPos4 <= ybPos4 + 1;
        if (ybPos4 >= 4)
            ybPos4 <= ybPos4 + speed*2;
        if (ybPos4 >= 480)
            ybPos4 <= 0;
        if(xPos>217 && xPos<277 && ybPos4>=440 && ybPos4<=445) begin
            score <= score - 1;
            ybPos4 <= 0;
        end
        
        if(bombNum == 4 && ybPos5 == 0 && score >= impossible) 
            ybPos5 <= ybPos5 + 1;
        if (ybPos5 >= 1)
            ybPos5 <= ybPos5 + speed*2;
        if (ybPos5 >= 480)
            ybPos5 <= 0;
        if(xPos>269 && xPos<329 && ybPos5>=440 && ybPos5<=445) begin
            score <= score - 1;
            ybPos5 <= 0;
        end
        
        if(bombNum == 5 && ybPos6 == 0 && score >= impossible) 
            ybPos6 <= ybPos6 + 1;
        if (ybPos6 >= 1)
            ybPos6 <= ybPos6 + speed*2;
        if (ybPos6 >= 480)
            ybPos6 <= 0;
        if(xPos>311 && xPos<371 && ybPos6>=440 && ybPos6<=445) begin
            score <= score - 1;
            ybPos6 <= 0;
        end
        
        if(bombNum == 6 && ybPos7 == 0 && score >= impossible) 
            ybPos7 <= ybPos7 + 1;
        if (ybPos7 >= 1)
            ybPos7 <= ybPos7 + speed*2;
        if (ybPos7 >= 480)
            ybPos7 <= 0;
        if(xPos>403 && xPos<463 && ybPos7>=440 && ybPos7<=445) begin
            score <= score - 1;
            ybPos7 <= 0;
        end
        
        if(bombNum == 7 && ybPos8 == 0 && score >= impossible) 
            ybPos8 <= ybPos8 + 1;
        if (ybPos8 >= 1)
            ybPos8 <= ybPos8 + speed*2;
        if (ybPos8 >= 480)
            ybPos8 <= 0;
        if(xPos>465 && xPos<525 && ybPos8>=440 && ybPos8<=445) begin
            score <= score - 1;
            ybPos8 <= 0;
        end
        
        if(bombNum == 8 && ybPos9 == 0 && score >= impossible) 
            ybPos9 <= ybPos9 + 1;
        if (ybPos9 >= 1)
            ybPos9 <= ybPos9 + speed*2;
        if (ybPos9 >= 480)
            ybPos9 <= 0;
        if(xPos>527 && xPos<587 && ybPos9>=440 && ybPos9<=445) begin
            score <= score - 1;
            ybPos9 <= 0;
        end

    end
    end
    
    assign brick1 = ((x > 21) & (y > yPos1-10) & (x < 41) & (y < yPos1 + 10)) ? 1 : 0;
    assign brick2 = ((x > 83) & (y > yPos2-10) & (x < 103) & (y < yPos2 + 10)) ? 1 : 0;
    assign brick3 = ((x > 145) & (y > yPos3-10) & (x < 165) & (y < yPos3 + 10)) ? 1 : 0;
    assign brick4 = ((x > 207) & (y > yPos4-10) & (x < 227) & (y < yPos4 + 10)) ? 1 : 0;
    assign brick5 = ((x > 269) & (y > yPos5-10) & (x < 289) & (y < yPos5 + 10)) ? 1 : 0;
    assign brick6 = ((x > 331) & (y > yPos6-10) & (x < 351) & (y < yPos6 + 10)) ? 1 : 0;
    assign brick7 = ((x > 393) & (y > yPos7-10) & (x < 413) & (y < yPos7 + 10)) ? 1 : 0;
    assign brick8 = ((x > 455) & (y > yPos8-10) & (x < 475) & (y < yPos8 + 10)) ? 1 : 0;
    assign brick9 = ((x > 517) & (y > yPos9-10) & (x < 537) & (y < yPos9 + 10)) ? 1 : 0;
    assign brick10 = ((x > 578) & (y > yPos10-10) & (x < 598) & (y < yPos10 + 10)) ? 1 : 0;
    
    assign bomb1 = ((x > 51) & (y > ybPos1-10) & (x < 71) & (y < ybPos1 + 10)) ? 1 : 0;
    assign bomb2 = ((x > 113) & (y > ybPos2-10) & (x < 133) & (y < ybPos2 + 10)) ? 1 : 0;
    assign bomb3 = ((x > 175) & (y > ybPos3-10) & (x < 195) & (y < ybPos3 + 10)) ? 1 : 0;
    assign bomb4 = ((x > 237) & (y > ybPos4-10) & (x < 257) & (y < ybPos4 + 10)) ? 1 : 0;
    assign bomb5 = ((x > 299) & (y > ybPos5-10) & (x < 319) & (y < ybPos5 + 10)) ? 1 : 0;
    assign bomb6 = ((x > 361) & (y > ybPos6-10) & (x < 381) & (y < ybPos6 + 10)) ? 1 : 0;
    assign bomb7 = ((x > 423) & (y > ybPos7-10) & (x < 443) & (y < ybPos7 + 10)) ? 1 : 0;
    assign bomb8 = ((x > 485) & (y > ybPos8-10) & (x < 505) & (y < ybPos8 + 10)) ? 1 : 0;
    assign bomb9 = ((x > 547) & (y > ybPos9-10) & (x < 567) & (y < ybPos9 + 10)) ? 1 : 0;
    
    /////////////////////////GO AND END///////////////////////////////
    
    wire G1, G2, G3, G4, G5;
    wire O1, O2, O3, O4;
    
    wire E1, E2, E3, E4; 
    wire N1, N2, N3, N4, N5; 
    wire D1, D2, D3, D4;
    
    assign G1 =  ((x >= 230) & (y > 140) & (x < 290) & (y < 160)) ? 1 : 0;  
    assign G2 =  ((x > 210) & (y > 140) & (x < 230) & (y < 240)) ? 1 : 0; 
    assign G3 =  ((x >= 230) & (y > 220) & (x < 290) & (y < 240)) ? 1 : 0; 
    assign G4 =  ((x > 270) & (y > 180) & (x < 290) & (y <= 220)) ? 1 : 0; 
    assign G5 =  ((x > 250) & (y > 180) & (x <= 270) & (y < 200)) ? 1 : 0; 
    
    assign O1 =  ((x >=350 ) & (y > 140) & (x < 410) & (y < 160)) ? 1 : 0;  
    assign O2 =  ((x > 330) & (y > 140) & (x < 350) & (y < 240)) ? 1 : 0; 
    assign O3 =  ((x >= 350) & (y > 220) & (x < 410) & (y < 240)) ? 1 : 0; 
    assign O4 =  ((x > 390) & (y >=160) & (x < 410) & (y <= 220)) ? 1 : 0; 
    
    assign E1 = ((x > 160) & (y > 140) & (x < 180) & (y < 240)) ? 1 : 0;
    assign E2 = ((x >= 180) & (y > 220) & (x < 240) & (y < 240)) ? 1 : 0;
    assign E3 = ((x >= 180) & (y > 180) & (x < 240) & (y < 200)) ? 1 : 0;
    assign E4 = ((x >= 180) & (y > 140) & (x < 240) & (y < 160)) ? 1 : 0;
    
    assign N1 = ((x > 260) & (y > 140) & (x < 280) & (y < 240)) ? 1 : 0;
    assign N2 = ((x >= 280) & (y > 160) & (x < 300) & (y <= 180)) ? 1 : 0;
    assign N3 = ((x >= 300) & (y > 180) & (x < 320) & (y <= 200)) ? 1 : 0;
    assign N4 = ((x >= 320) & (y > 200) & (x < 340) & (y <= 220)) ? 1 : 0;
    assign N5 = ((x >= 340) & (y > 140) & (x < 360) & (y < 240)) ? 1 : 0;
    
    assign D1 = ((x > 380) & (y > 140) & (x < 400) & (y < 240)) ? 1 : 0;
    assign D2 = ((x >= 400) & (y > 220) & (x < 440) & (y < 240)) ? 1 : 0;
    assign D3 = ((x >= 400) & (y > 140) & (x < 440) & (y < 160)) ? 1 : 0;
    assign D4 = ((x >= 440) & (y > 160) & (x < 460) & (y < 220)) ? 1 : 0;
    
    wire begin_word, end_word;
    
    assign begin_word = O1 + O2 + O3 + O4 + G1 + G2 + G3 + G4 + G5;
    assign end_word = E1 + E2 + E3 + E4 + N1 + N2 + N3 + N4 + N5 + D1 + D2 + D3 + D4; 
    

    ////////////////////////////////////////////////////////
 
    always@(posedge CLK) begin
    if (enter == 0)
        VGA_G[3] = begin_word;
    else if (seconds == 0) begin
        VGA_R[3] = end_word;     
    end
    else begin
        VGA_G[3] = brick1 + brick2 + brick3 + brick4 + brick5 + brick6 + brick7 + brick8 + brick9 + paddle;
        VGA_R[3] = brick1 + brick2 + brick3 + brick4 + brick5 + brick6 + brick7 + brick8 + brick9 + bomb1 + bomb2 + bomb3 + bomb4 + bomb5 + bomb6 + bomb7 + bomb8 + bomb9;
        VGA_B[3] = brick1 + brick2 + brick3 + brick4 + brick5 + brick6 + brick7 + brick8 + brick9;
    end
    end
    

    score_display score_display1(.CLK(CLK), .RST_BTN(RST_BTN), .score(score), .countdown(seconds), .Anode_Activate(Anode_Activate), .LED_out(LED_out)); 
    
endmodule

