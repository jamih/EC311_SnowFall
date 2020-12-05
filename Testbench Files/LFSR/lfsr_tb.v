`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 04:40:49 PM
// Design Name: 
// Module Name: lfsr_tb
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


module lfsr_tb();

    // Output
    wire [23:0] out; 
  
    // Inputs
    reg clk, rst; 
    reg [3:0] num; 
    
    // Instantiation 
    lfsr lfsr1(.out(out), .clk(clk), .rst(rst), .num(num));

    initial
    begin
        clk = 0; 
        rst = 1; 
        num = 9; // Testing out the pseudo-randomization when currentNum is 9 
        #100; 
        
        rst = 0; 
        #500; 
    end
    
    always
    begin
        #5; 
        clk = ~clk; 
    end 
    
endmodule