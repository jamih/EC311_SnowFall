`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2020 05:55:04 PM
// Design Name: 
// Module Name: score_display
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

module score_display(
    input CLK, 
    input RST_BTN, // reset
    input [7:0] score,
    input [7:0] countdown,
    output reg [7:0] Anode_Activate, 
    output reg [6:0] LED_out
    );
    
    reg [26:0] one_second_counter; 
    wire one_second_enable;
    reg [7:0] displayed_number; 
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; 
             
    wire [1:0] LED_activating_counter; 
    
    always @ (*)
    begin
    displayed_number = score; 
    end
    
    //convert score value from binary to binary coded decimal
    wire [3:0] tens, ones, c_tens, c_ones;
    bin_to_bcd b1(.binary(displayed_number), .Tens(tens), .Ones(ones));
    bin_to_bcd b2(.binary(countdown), .Tens(c_tens), .Ones(c_ones));
    
    
   //create counter to slow down clock
   always@(posedge CLK)
begin
    if(refresh_counter == 1048576)
        refresh_counter <= 0;
    else
        refresh_counter <= refresh_counter + 1;
end 
    
    assign LED_activating_counter = refresh_counter[19:18];

    always @ (*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            // activate LED1 and deactivate the rest
            Anode_Activate = 8'b01111111; 
            //Display tens digit of score value
            LED_BCD = tens;
              end
        2'b01: begin
            // activate LED2 and deactivate the rest
            Anode_Activate = 8'b10111111; 
            //Display ones digit of score value
            LED_BCD = ones;
              end
        2'b10: begin
            // activate LED7 and deactivate the rest
            Anode_Activate = 8'b11111101; 
            //Display tens digit of countdown timer
            LED_BCD = c_tens;
                end
        2'b11: begin
            // activate LED8 and deactivate the rest
            Anode_Activate = 8'b11111110; 
            // the fourth digit of the 16-bit number
            LED_BCD = c_ones;
               end
        endcase
    end
    
    //Assign value to be displayed to the correct cathode combination
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        default: LED_out = 7'b0000001; // "0"
        endcase
        
        $display("Current score %d", score);
    end
    
endmodule


