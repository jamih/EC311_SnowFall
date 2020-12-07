`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2020 10:33:24 AM
// Design Name: 
// Module Name: bin_to_bcd_tb
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


module bin_to_bcd_tb();

    // Inputs
    reg [7:0] binary; 
    
    // Output
    wire [3:0] Tens; 
    wire [3:0] Ones; 
    
    bin_to_bcd bin_to_bcd1(.binary(binary), .Tens(Tens), .Ones(Ones));
    
    integer i; 

    initial
    begin
        for (i = 0; i < 255; i = i + 1) // To test all of possibilities of 8 bits
        begin
            binary = i; 
            #5; 
        end
    end
    
endmodule
