`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 05:42:30 PM
// Design Name: 
// Module Name: music_tb
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


module music_tb();

    // Inputs
    reg clk; 
    reg [7:0] address; 
    
    // Output
	wire [7:0] note;
    
    // Instantiation 
    music_ROM music_ROM1(.clk(clk), .address(address), .note(note));
    
    integer i; 
    
    initial
    begin
        clk = 0; 
        #1; 
	for (i = 0; i < 200; i = i + 1) // To test all the addresses in the ROM that we're using to produce a note
        begin
            address = i; 
            #5; 
        end
    end 

    always
    begin
        clk = ~clk; 
        #1;
    end 
    
endmodule
