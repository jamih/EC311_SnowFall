`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2020 05:56:59 PM
// Design Name: 
// Module Name: lfsr
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

module lfsr (

  output reg [23:0] out,
  input clk, rst,
  input [3:0] num
);
  wire feedback;

  assign feedback = ~(out[23] ^ out[22] ^ out[21] ^ out[16]);

always @(posedge clk, posedge rst)
  begin
    if (rst)
      out = 4'b0;
    else
      out = {out[22:0],feedback};
  end
  //assign last four bits as output to select which block to drop
  assign num = out[3:0];
endmodule
