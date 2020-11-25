module EENG_220_PROJECT(KEY0, KEY1, DisplayGround, inputDisplay, SW, LEDR, MAX10_CLK1_50, ADC_CLK_10, BUZZER);
	input [9:0] SW;
	input MAX10_CLK1_50, ADC_CLK_10, KEY0, KEY1;
	
	output [6:0] inputDisplay;
    output [4:0] DisplayGround;
	output BUZZER;
	
	wire [3:0] SEC_ONE, SEC_TEN, MIN_ONE, MIN_TEN, HOUR_ONE, HOUR_TEN;
	wire [7:0] SET_IN;
	wire [7:0] a_min, a_hour;
	
	assign a_hour = 8'b00000110;
	assign a_min = 8'b00110000;
	
	assign LEDR[9:0] = SW[9:0];
	assign SET_IN = SW[7:0];
	
	clock C1(MAX10_CLK1_50, KEY1, KEY0, SW[9], SET_IN, HOUR_ONE, HOUR_TEN, MIN_ONE, MIN_TEN, SEC_ONE, SEC_TEN, a_min, a_hour, SW[8],BUZZER);
	Display alarmDisplay(ADC_CLK_10, MIN_ONE, MIN_TEN, HOUR_ONE, HOUR_TEN, DisplayGround, inputDisplay);
	// Display timerDisplay(ADC_CLK_10, MIN_TEN, MIN_ONE, SEC_TEN, SEC_ONE, DisplayGround, inputDisplay);
	
endmodule 