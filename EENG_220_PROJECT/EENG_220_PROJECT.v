module EENG_220_PROJECT(KEY0, KEY1, inputDisplay, DisplayGround, SW, LEDR, CLOCK_50, ADC_CLK_10, BUZZER);
	input [9:0] SW;
	input CLOCK_50, KEY0, KEY1, ADC_CLK_10;
	
	output [9:0] LEDR;
	output BUZZER;
   output [6:0] inputDisplay;
   output [4:0] DisplayGround;
	
	wire [3:0] SEC_ONE, SEC_TEN, MIN_ONE, MIN_TEN, HOUR_ONE, HOUR_TEN, A_HOUR_ONE, A_HOUR_TEN, A_MIN_ONE, A_MIN_TEN, OUT_HOUR_ONE, OUT_HOUR_TEN, OUT_MIN_ONE, OUT_MIN_TEN, OUT_SEC_ONE, OUT_SEC_TEN;
	wire [7:0] SET_IN;
	wire SWITCH, SET, ALARM_ON;
	
	assign LEDR[9:0] = SW[9:0];
	assign SET_IN = SW[7:0];
	assign SWITCH = SW[8];
	assign SET = KEY1;
	
	reg SET_TIME = 0, SET_ALARM = 0;
	
	//If the right rotary encoder button gets pushed
	//turn on/off set time mode
	always@(negedge KEY0)begin
		if (!ALARM_ON) begin
			if (SET_TIME)
				SET_TIME <= 0;
			else
				SET_TIME <= 1;
		end
		else begin
			if (SET_ALARM)
				SET_ALARM <= 0;
			else
				SET_ALARM <= 1;
		end
	end
	
	//If the left rotary encoder button gets pushed
	/*//turn on/off the alarm
	always@(negedge KEY1)begin
		if (ALARM_ON)
			ALARM_ON <= 0;
		else
			ALARM_ON <= 1;
	end*/
	assign ALARM_ON = SW[9];
	
	
	clock C1(CLOCK_50, SWITCH, SET_IN, SET, SET_TIME, SET_ALARM, HOUR_ONE, HOUR_TEN, MIN_ONE, MIN_TEN, SEC_ONE, SEC_TEN, A_MIN_ONE, A_MIN_TEN, A_HOUR_ONE, A_HOUR_TEN, ALARM_ON ,BUZZER);
	
	assign OUT_SEC_ONE = (SET_ALARM) ? 8'b00000000 : SEC_ONE;
	assign OUT_SEC_TEN = (SET_ALARM) ? 8'b00000000 : SEC_TEN;
	assign OUT_MIN_ONE = (SET_ALARM) ? A_MIN_ONE : MIN_ONE;
	assign OUT_MIN_TEN = (SET_ALARM) ? A_MIN_TEN : MIN_TEN;
	assign OUT_HOUR_ONE = (SET_ALARM) ? A_HOUR_ONE : HOUR_ONE;
	assign OUT_HOUR_TEN = (SET_ALARM) ? A_HOUR_TEN : HOUR_TEN;
	
	Display alarmDisplay(ADC_CLK_10, OUT_MIN_ONE, OUT_MIN_TEN, OUT_HOUR_ONE, OUT_HOUR_TEN, DisplayGround, inputDisplay);
	
endmodule 