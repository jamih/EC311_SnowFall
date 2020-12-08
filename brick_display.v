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
    input PS2_DATA,             // reset button
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output reg [3:0] VGA_R,     // 4-bit VGA red output
    output reg [3:0] VGA_G,     // 4-bit VGA green output
    output reg [3:0] VGA_B,     // 4-bit VGA blue output
    output wire [7:0] Anode_Activate, // anode signals of the 7-segment LED display
    output wire [6:0] LED_out, // cathode patterns of the 7-segment LED display
    output wire speaker
    );

    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
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
     
     // make millisecond clock
     always @(posedge CLK)
       begin
      if(counter_1M == MAX_COUNT)
            counter_1M <=0;
        else
            counter_1M <= counter_1M + 1'b1;
     end
     
    assign counter_en = counter_1M == 0;
    
    
    //make 0.5 millisecond clock
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
    
    
    //create 90 second countdown timer that resets when the game ends
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
    
    
    // draw the initial paddle rectangle
 
    reg [3:0] impossible = 10;     //impossible level starts when the score is 10
    reg [1:0] pSpeed = 2;

    
    always@(posedge CLK)
     begin
        if(counter_paddle)
            //when left arrow key is pressed, move paddle left
            if (keycode[7:0] == 8'h6b)
                //paddle wraps around to the right side when it reaches the left edge of the screen
                if(xPos <= 20)
                    xPos = 600;
                else
                    xPos = xPos - pSpeed;
            //when right arrow key is pressed, move paddle right
            else if (keycode[7:0] == 8'h74)
                if(xPos >= 600)
                    //paddle wraps around to the left side when it reaches the right edge of the screen
                    xPos = 20;
                else
                    xPos = xPos + pSpeed;
       end
        
       //assign paddle position to pixel values
       assign paddle =  ((x > xPos-20 ) & (y > 450) & (x < xPos +20) & (y < 460)) ? 1 : 0;
       
      

    wire brick1, brick2, brick3, brick4, brick5, brick6, brick7, brick8, brick9, brick10;
    wire bomb1, bomb2, bomb3, bomb4, bomb5, bomb6, bomb7, bomb8, bomb9;
    
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

    
    
    reg [3:0] currentNum;
    reg [3:0] bombNum;
    wire [3:0] num;
    wire [3:0] num2;
    wire [3:0] out;
    reg start = 1;
    reg s = 0;
    
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
        //if enter key is pressed, start game
        if (keycode[7:0] == 8'h5A)
            enter = 1;
        //if backspace key is pressed go from end screen to start screen
        if (keycode[7:0] == 8'h66)
            enter = 0;
    end

    //generate random number using LFSR
    lfsr L(.num(num), .out(out), .clk(CLK), .rst(start));
    lfsr L2(.num(num2), .out(out2), .clk(counter_en), .rst(start));
    
    //use random number to select which block will drop
    always @(posedge CLK) begin
        if (counter_en1) begin
            currentNum <= num;
            bombNum <= num2;
        end
    end
            
    reg [2:0] speed = 2;
    reg [1:0] lostHeart = 0;
    reg death = 0;
    wire heart1, heart2, heart3;
    
    //set speed at which blocks fall based on level
    always @(posedge CLK) begin
        if (score >= impossible)
        speed = 3;
        if (enter == 0)
        speed = 2;
    end
    
    //Drop random block
    always @(posedge CLK)
    begin
    if (counter_en) begin
        
        //reset score when returning to start screen
        if(enter == 0)
            score = 0;
            
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 0 && yPos1 == 0) 
            yPos1 <= yPos1 + 1;
        if (yPos1 >= 1)
            yPos1 <= yPos1 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos1 >= 480) begin
            yPos1 <= 0;           
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>01 && xPos<61 && yPos1>=440 && yPos1<=445) begin
            score <= score + 1;
            yPos1 <= 0;
        end
        
             
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 1 && yPos2 == 0) 
            yPos2 <= yPos2 + 1;
        if (yPos2 >= 1)
            yPos2 <= yPos2 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos2 >= 480) begin
            yPos2 <= 0;
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>63 && xPos<123 && yPos2>=440 && yPos2<=445) begin
            score <= score + 1;
            yPos2 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 2 && yPos3 == 0) 
            yPos3 <= yPos3 + 1;
        if (yPos3 >= 1)
            yPos3 <= yPos3 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos3 >= 480) begin
            yPos3 <= 0;
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>125 && xPos<185 && yPos3>=440 && yPos3<=445) begin
            score <= score + 1;
            yPos3 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 3 && yPos4 == 0) 
            yPos4 <= yPos4 + 1;
        if (yPos4 >= 4)
            yPos4 <= yPos4 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos4 >= 480) begin
            yPos4 <= 0;
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>187 && xPos<247 && yPos4>=440 && yPos4<=445) begin
            score <= score + 1;
            yPos4 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 4 && yPos5 == 0) 
            yPos5 <= yPos5 + 1;
        if (yPos5 >= 1)
            yPos5 <= yPos5 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos5 >= 480) begin
            yPos5 <= 0;
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>249 && xPos<309 && yPos5>=440 && yPos5<=445) begin
            score <= score + 1;
            yPos5 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 5 && yPos6 == 0) 
            yPos6 <= yPos6 + 1;
        if (yPos6 >= 1)
            yPos6 <= yPos6 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos6 >= 480) begin
            yPos6 <= 0;
            lostHeart <= lostHeart + 1;
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>311 && xPos<371 && yPos6>=440 && yPos6<=445) begin
            score <= score + 1;
            yPos6 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 6 && yPos7 == 0) 
            yPos7 <= yPos7 + 1;
        if (yPos7 >= 1)
            yPos7 <= yPos7 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos7 >= 480) begin
            yPos7 <= 0;
            lostHeart <= lostHeart + 1;
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>373 && xPos<433 && yPos7>=440 && yPos7<=445) begin
            score <= score + 1;
            yPos7 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 7 && yPos8 == 0) 
            yPos8 <= yPos8 + 1;
        if (yPos8 >= 1)
            yPos8 <= yPos8 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos8 >= 480) begin
            yPos8 <= 0;
            lostHeart <= lostHeart + 1;
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>435 && xPos<495 && yPos8>=440 && yPos8<=445) begin
            score <= score + 1;
            yPos8 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 8 && yPos9 == 0) 
            yPos9 <= yPos9 + 1;
        if (yPos9 >= 1)
            yPos9 <= yPos9 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos9 >= 480) begin
            yPos9 <= 0;            
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>497 && xPos<557 && yPos9>=440 && yPos9<=445) begin
            score <= score + 1;
            yPos9 <= 0;
        end
        
        
        //if random number corresponds to this block, and this block isn't already falling, drop block
        if(currentNum == 9 && yPos10 == 0) 
            yPos10 <= yPos10 + 1;
        if (yPos10 >= 1)
            yPos10 <= yPos10 + speed;
        //Once block reaches bottom of screen, place it back at the top
        if (yPos10 >= 480) begin
            yPos10 <= 0;            
        end
        //if paddle and block collide, increase score, place block back at top
        if(xPos>558 && xPos<618 && yPos10>=440 && yPos10<=445) begin
            score <= score + 1;
            yPos10 <= 0;
        end
        
        ////////////////////////////////BOMBS!!!!!!!!!!!!!!/////////////////////////////////////////////
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 0 && ybPos1 == 0 && score>= impossible) 
            ybPos1 <= ybPos1 + 1;
        if (ybPos1 >= 1) 
            ybPos1 <= ybPos1 + speed*2;
        //Once bomb reaches bottom of screen, place it back at the top
        if (ybPos1 >= 480) 
            ybPos1 <= 0; 
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>31 && xPos<91 && ybPos1>=440 && ybPos1<=445) begin
            score <= score - 1;
            ybPos1 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 1 && ybPos2 == 0 && score >= impossible)
            ybPos2 <= ybPos2 + 1;
        if (ybPos2 >= 1)       
            ybPos2 <= ybPos2 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos2 >= 480)
            ybPos2 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>93 && xPos<153 && ybPos2>=440 && ybPos2<=445) begin
            score <= score - 1;
            ybPos2 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 2 && ybPos3 == 0 && score >= impossible) 
            ybPos3 <= ybPos3 + 1;
        if (ybPos3 >= 1)
            ybPos3 <= ybPos3 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos3 >= 480)
            ybPos3 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>155 && xPos<215 && ybPos3>=440 && ybPos3<=445) begin
            score <= score - 1;
            ybPos3 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 3 && ybPos4 == 0 && score >= impossible) 
            ybPos4 <= ybPos4 + 1;
        if (ybPos4 >= 4)
            ybPos4 <= ybPos4 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos4 >= 480)
            ybPos4 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>217 && xPos<277 && ybPos4>=440 && ybPos4<=445) begin
            score <= score - 1;
            ybPos4 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 4 && ybPos5 == 0 && score >= impossible) 
            ybPos5 <= ybPos5 + 1;
        if (ybPos5 >= 1)
            ybPos5 <= ybPos5 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos5 >= 480)
            ybPos5 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>269 && xPos<329 && ybPos5>=440 && ybPos5<=445) begin
            score <= score - 1;
            ybPos5 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 5 && ybPos6 == 0 && score >= impossible) 
            ybPos6 <= ybPos6 + 1;
        if (ybPos6 >= 1)
            ybPos6 <= ybPos6 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos6 >= 480)
            ybPos6 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>311 && xPos<371 && ybPos6>=440 && ybPos6<=445) begin
            score <= score - 1;
            ybPos6 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 6 && ybPos7 == 0 && score >= impossible) 
            ybPos7 <= ybPos7 + 1;
        if (ybPos7 >= 1)
            ybPos7 <= ybPos7 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos7 >= 480)
            ybPos7 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>403 && xPos<463 && ybPos7>=440 && ybPos7<=445) begin
            score <= score - 1;
            ybPos7 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 7 && ybPos8 == 0 && score >= impossible) 
            ybPos8 <= ybPos8 + 1;
        if (ybPos8 >= 1)
            ybPos8 <= ybPos8 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos8 >= 480)
            ybPos8 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>465 && xPos<525 && ybPos8>=440 && ybPos8<=445) begin
            score <= score - 1;
            ybPos8 <= 0;
        end
        
        
        //if random number corresponds to this bomb, and this bomb isn't already falling, drop bomb
        if(bombNum == 8 && ybPos9 == 0 && score >= impossible) 
            ybPos9 <= ybPos9 + 1;
        if (ybPos9 >= 1)
            ybPos9 <= ybPos9 + speed*2;
        //Once block reaches bottom of screen, place it back at the top
        if (ybPos9 >= 480)
            ybPos9 <= 0;
        //if paddle and bomb collide, decrease score, place bomb back at top
        if(xPos>527 && xPos<587 && ybPos9>=440 && ybPos9<=445) begin
            score <= score - 1;
            ybPos9 <= 0;
        end

    end
    end
    
    //setup for blocks
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
    
    //setup for bombs
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
    
    /////////////////////////HEARTS///////////////////////////////
    
    wire H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, H13, H14, H15, H16, heart1, heart2;
    
    
    assign H1 = ((x > 510) & (y >180) & (x < 515) & (y <= 185)) ? 1 : 0;
    assign H2 = ((x > 530) & (y >= 180) & (x < 535) & (y <=185)) ? 1 : 0;
    assign H3 = ((x > 505) & (y > 185) & (x < 520) & (y <= 190)) ? 1 : 0;
    assign H4 = ((x > 525) & (y > 185) & (x < 540) & (y <= 190)) ? 1 : 0;
    assign H5 = ((x > 505) & (y >190) & (x < 540) & (y <= 195)) ? 1 : 0;
    assign H6 = ((x > 510) & (y > 195) & (x < 535) & (y <= 200)) ? 1 : 0;
    assign H7 = ((x > 515) & (y > 200) & (x < 530) & (y <= 205)) ? 1 : 0;
    assign H8 = ((x > 520) & (y > 205) & (x < 525) & (y <= 210)) ? 1 : 0; 
    
    assign H9 = ((x > 510) & (y >180) & (x < 515) & (y <= 185)) ? 1 : 0;
    assign H10 = ((x > 530) & (y >= 180) & (x < 535) & (y <=185)) ? 1 : 0;
    assign H11= ((x > 505) & (y > 185) & (x < 520) & (y <= 190)) ? 1 : 0;
    assign H12 = ((x > 525) & (y > 185) & (x < 540) & (y <= 190)) ? 1 : 0;
    assign H13 = ((x > 505) & (y >190) & (x < 540) & (y <= 195)) ? 1 : 0;
    assign H14 = ((x > 510) & (y > 195) & (x < 535) & (y <= 200)) ? 1 : 0;
    assign H15 = ((x > 515) & (y > 200) & (x < 530) & (y <= 205)) ? 1 : 0;
    assign H16 = ((x > 520) & (y > 205) & (x < 525) & (y <= 210)) ? 1 : 0; 
   
   assign heart1 = H9 + H10 + H11 + H12 + H13 + H14 + H15 + H16;
   assign heart2 = H1 + H2 + H3 + H4 + H5 + H6 + H7 + H8; 

    

    ////////////////////////////////////////////////////////
 
    always@(posedge CLK) begin
    //if enter has not been pressed stay at start screen
    if (enter == 0)
        VGA_G[3] = begin_word + heart1;
        
    //if time ends go to end screen
    else if (seconds == 0) begin
        VGA_R[3] = end_word + heart2;     
    end
    
    //otherwise display falling blocks and paddle
    else begin
        VGA_G[3] = brick1 + brick2 + brick3 + brick4 + brick5 + brick6 + brick7 + brick8 + brick9 + paddle;
        VGA_R[3] = brick1 + brick2 + brick3 + brick4 + brick5 + brick6 + brick7 + brick8 + brick9 + bomb1 + bomb2 + bomb3 + bomb4 + bomb5 + bomb6 + bomb7 + bomb8 + bomb9;
        VGA_B[3] = brick1 + brick2 + brick3 + brick4 + brick5 + brick6 + brick7 + brick8 + brick9;
    end
    end
    

    score_display score_display1(.CLK(CLK), .RST_BTN(RST_BTN), .score(score), .countdown(seconds), .Anode_Activate(Anode_Activate), .LED_out(LED_out)); 
    
endmodule

