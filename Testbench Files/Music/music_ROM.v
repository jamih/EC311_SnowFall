`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2020 07:48:56 PM
// Design Name: 
// Module Name: music_ROM
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



module music_ROM(
	input clk,
	input [7:0] address,
	output reg [7:0] note
);

  parameter MAX_COUNT1 = 1_000_000 - 1;
     reg [26:0] counter_100M;
     wire counter_en1;

always @(posedge clk)
       begin
      if(counter_100M == MAX_COUNT1)
            counter_100M <=0;
        else
            counter_100M <= counter_100M + 1'b1;
     end
     
    assign counter_en1 = counter_100M == 0;

always @(posedge clk)

case(address)
	  0: note<= 8'd27;
	  1: note<= 8'd27;
	  2: note<= 8'd27;
	  3: note<= 8'd27;
	  4: note<= 8'd27;
	  5: note<= 8'd0;
	  6: note<= 8'd0;
	  7: note<= 8'd27;
	  8: note<= 8'd27;
	  9: note<= 8'd27;
	 10: note<= 8'd27;
	 11: note<= 8'd27;
	 12: note<= 8'd0;
	 13: note<= 8'd0;
	 14: note<= 8'd27;
	 15: note<= 8'd27;
	 16: note<= 8'd27;
	 17: note<= 8'd27;
	 18: note<= 8'd27;
	 19: note<= 8'd27;
	 20: note<= 8'd27;
	 21: note<= 8'd27;
	 22: note<= 8'd27;
	 23: note<= 8'd27;
	 24: note<= 8'd00;
	 25: note<= 8'd00;
	 26: note<=8'd27;
	 27: note<=8'd27;
	 28: note<=8'd27;
	 29: note<=8'd27;
	 30: note<=8'd27;
	 31: note<=8'd0; 
	 32: note<=8'd0; 
	 33: note<=8'd27;
	 34: note<=8'd27;
	 35: note<=8'd27;
	 36: note<=8'd27;
	 37: note<=8'd27;
	 38: note<=8'd0; 
	 39: note<=8'd0; 
	 40: note<=8'd27;
	 41: note<=8'd27;
	 42: note<=8'd27;
	 43: note<=8'd27;
	 44: note<=8'd27;
	 45: note<=8'd27;
	 46: note<=8'd27;
	 47: note<=8'd27;
	 48: note<=8'd27;
	 49: note<=8'd27;
	 50: note<=8'd00;
	 51: note<=8'd00;
	 52: note<=8'd27;
	 53: note<=8'd27;
	 54: note<=8'd27;
	 55: note<=8'd27;
	 56: note<=8'd27;
	 57: note<=8'd00;
	 58: note<=8'd00;
	 59: note<=8'd30;
	 60: note<=8'd30;
	 61: note<=8'd30;
	 62: note<=8'd30;
	 63: note<=8'd30;
	 64: note<=8'd00;
	 65: note<=8'd00;
	 66: note<=8'd23;
	 67: note<=8'd23;
	 68: note<=8'd23;
	 69: note<=8'd23;
	 70: note<= 8'd23;
	 71: note<= 8'd23;
	 72: note<= 8'd00;
	 73: note<= 8'd00;
	 74: note<= 8'd25;
	 75: note<= 8'd25;
	 76: note<= 8'd25;
	 77: note<= 8'd25;
	 78: note<= 8'd25;
	 79: note<= 8'd25;
	 80: note<= 8'd00;
	 81: note<= 8'd00;
	 
	 82: note<= 8'd27;
	 83: note<= 8'd27;
	 84: note<= 8'd27;
	 85: note<= 8'd27;
	 86: note<= 8'd27;
	 87: note<= 8'd27;
	 88: note<= 8'd27;
	 89: note<= 8'd27;
	 90: note<= 8'd27;
	 91: note<= 8'd27;
	 92: note<= 8'd27;
	 
	 93: note<= 8'd27;
	 94: note<= 8'd27;
	 95: note<= 8'd27;
	 96: note<= 8'd27;
	 97: note<= 8'd27;
	 	 
	 98: note<= 8'd28;
	 98: note<= 8'd28;
	 99: note<= 8'd28;
	 100: note<= 8'd28;
	 101: note<= 8'd28;
	 
	102: note<= 8'd00;
	103: note<= 8'd00;
	
	103: note<= 8'd28;
	104: note<= 8'd28;
	105: note<= 8'd28;
	106: note<= 8'd28;
	107: note<= 8'd28;
	
	108: note<= 8'd00;
	109: note<= 8'd00;
	
	110: note<= 8'd28;
	111: note<= 8'd28;
	112: note<= 8'd28;
	113: note<= 8'd28;
	114: note<= 8'd28;
	
	115: note<= 8'd00;
	116: note<= 8'd00;
	
	117: note<= 8'd28;
	118: note<= 8'd28;
	119: note<= 8'd28;
	120: note<= 8'd28;
	121: note<= 8'd28;
	
	122: note<= 8'd00;
	123: note<= 8'd00;
	
	124: note<= 8'd28;
	125: note<= 8'd28;
	126: note<= 8'd28;
	127: note<= 8'd28;
	128: note<= 8'd28;
	
	130: note<= 8'd00;
	131: note<= 8'd00;
	
	132: note<= 8'd27;
	133: note<= 8'd27;
	134: note<= 8'd27;
	135: note<= 8'd27;
	136: note<= 8'd27;
	
	137: note<= 8'd00;
	138: note<= 8'd00;
	
	139: note<= 8'd27;
	140: note<= 8'd27;
	141: note<= 8'd27;
	142: note<= 8'd27;
	143: note<= 8'd27;
	
	144: note<= 8'd00;
	145: note<= 8'd00;
	
	146: note<= 8'd27;
	147: note<= 8'd27;
	148: note<= 8'd27;
	149: note<= 8'd27;
	150: note<= 8'd27;
	
	151: note<= 8'd00;
	152: note<= 8'd00;
	
	153: note<= 8'd27;
	154: note<= 8'd27;
	155: note<= 8'd27;
	156: note<= 8'd27;
	157: note<= 8'd27;
	
	158: note<= 8'd00;
	159: note<= 8'd00;
	
	160: note<= 8'd25;
	161: note<= 8'd25;
	162: note<= 8'd25;
	163: note<= 8'd25;
	164: note<= 8'd25;

	165: note<= 8'd00;
	166: note<= 8'd00;
	
	167: note<= 8'd25;
	168: note<= 8'd25;
	169: note<= 8'd25;
	170: note<= 8'd25;
	171: note<= 8'd25;
	
	172: note<= 8'd00;
	173: note<= 8'd00;
	
	174: note<= 8'd27;
	175: note<= 8'd27;
	176: note<= 8'd27;
	177: note<= 8'd27;
	178: note<= 8'd27;
	
	179: note<= 8'd00;
	180: note<= 8'd00;
	
	181: note<= 8'd25;
	182: note<= 8'd25;
	183: note<= 8'd25;
	184: note<= 8'd25;
	185: note<= 8'd25;
	186: note<= 8'd25;
	187: note<= 8'd25;
	188: note<= 8'd25;
	189: note<= 8'd25;
	190: note<= 8'd25;
	
	191: note<= 8'd30;
	192: note<= 8'd30;
	193: note<= 8'd30;
	194: note<= 8'd30;
	195: note<= 8'd30;
	196: note<= 8'd30;
	197: note<= 8'd30;
	198: note<= 8'd30;
	199: note<= 8'd30;
	200: note<= 8'd30;
//	201: note<= 8'd00;
//	202: note<= 8'd00;
//	203: note<= 8'd00;
//	204: note<= 8'd00;
//	205: note<= 8'd00;
//	206: note<= 8'd00;
//	207: note<= 8'd00;
//	208: note<= 8'd00;
//	209: note<= 8'd00;
//	210: note<= 8'd00;
//	211: note<= 8'd00;
//	212: note<= 8'd00;
//	213: note<= 8'd00;
//	214: note<= 8'd00;
//	215: note<= 8'd00;
//	216: note<= 8'd00;
//	217: note<= 8'd00;
//	218: note<= 8'd00;
//	219: note<= 8'd00;
//	220: note<= 8'd00;
//	221: note<= 8'd00;
//	222: note<= 8'd00;
//	223: note<= 8'd00;
//	224: note<= 8'd00;
//	225: note<= 8'd00;
//	226: note<= 8'd00;
//	227: note<= 8'd00;
//	228: note<= 8'd00;
//	229: note<= 8'd00;
//	230: note<= 8'd00;
//	231: note<= 8'd00;
//	232: note<= 8'd00;
//	233: note<= 8'd00;
//	234: note<= 8'd00;
//	235: note<= 8'd00;
//	236: note<= 8'd00;
//	237: note<= 8'd00;
//	238: note<= 8'd00;
//	239: note<= 8'd00;
//	240: note<= 8'd00;
//	241: note<= 8'd0;
//	242: note<= 8'd00;
	default: note <= 8'd0;
endcase
endmodule

/////////////////////////////////////////////////////
