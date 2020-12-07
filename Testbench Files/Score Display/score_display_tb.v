`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 05:04:06 PM
// Design Name: 
// Module Name: score_display_tb
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


module score_display_tb();
  
    // Inputs
    reg CLK, RST_BTN; 
    reg [7:0] score; 
    
    // Output
    wire [7:0] Anode_Activate; 
    
    // Instantiation 
    score_display score_display1(.CLK(CLK), .RST_BTN(RST_BTN), .score(score), .Anode_Activate(Anode_Activate)); 
    
    integer i; 

    initial
    begin
        CLK = 0; 
        RST_BTN = 1;
        #100; 
        
        RST_BTN = 0;
        for (i = 0; i < 100; i = i + 1) 
        begin
            score = i; 
            #10; 
        end
    end
    
    always
    begin
        #5; 
        CLK = ~CLK; 
    end 
    
endmodule
