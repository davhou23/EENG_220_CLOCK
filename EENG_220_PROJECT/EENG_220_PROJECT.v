module EENG_220_PROJECT(KEY0, KEY1, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SW, LEDR, CLOCK_50, BUZZER);
	input [9:0] SW;
	input CLOCK_50, KEY0, KEY1;
	
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output [9:0] LEDR;
	output BUZZER;
	
	wire [3:0] SEC_ONE, SEC_TEN, MIN_ONE, MIN_TEN, HOUR_ONE, HOUR_TEN;
	wire [7:0] SET_IN;
	wire [7:0] a_min, a_hour;
	
	assign a_hour = 8'b00000110;
	assign a_min = 8'b00110000;
	
	assign LEDR[9:0] = SW[9:0];
	assign SET_IN = SW[7:0];
	
	clock C1(CLOCK_50, KEY1, KEY0, SW[9], SET_IN, HOUR_ONE, HOUR_TEN, MIN_ONE, MIN_TEN, SEC_ONE, SEC_TEN, a_min, a_hour, SW[8],BUZZER);
	
	
	hex_display H0(SEC_ONE, HEX0);
	hex_display H1(SEC_TEN, HEX1);
	hex_display H2(MIN_ONE, HEX2);
	hex_display H3(MIN_TEN, HEX3);
	hex_display H4(HOUR_ONE, HEX4);
	hex_display H5(HOUR_TEN, HEX5);
	
endmodule 