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
    output reg [7:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
    
    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;// one second enable for counting numbers
    reg [7:0] displayed_number; // counting number to be displayed
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] LED_activating_counter; 
    
    always @ (*)
    begin
    displayed_number = score; 
    end

// always @(posedge CLK or posedge RST_BTN)
//    begin
//        if(RST_BTN==1)
//            displayed_number <= 0;
//        else begin
//            if(displayed_number>=99999999) 
//                 displayed_number <= 0;
//            else
//                displayed_number <= displayed_number + 1;
//        end
//    end 
    wire [3:0] tens, ones;
    bin_to_bcd b1(.binary(displayed_number), .Tens(tens), .Ones(ones));
    
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
            Anode_Activate = 8'b01111111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = tens;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            Anode_Activate = 8'b10111111; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = ones;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            Anode_Activate = 8'b01111111; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = tens;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            Anode_Activate = 8'b10111111; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = ones;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    
    // Cathode patterns of the 7-segment LED display 
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